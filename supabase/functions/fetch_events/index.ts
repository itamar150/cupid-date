import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// כל vibe מחולק ל-2 קבוצות — כל קבוצה = קריאת API אחת (מקסימום 20)
// קריאות מקבילות → ~30 תוצאות ייחודיות בסך הכל
const VIBE_TYPES: Record<string, [string[], string[]]> = {
  calm:      [['spa', 'museum', 'movie_theater'], ['art_gallery', 'library', 'cultural_center']],
  food:      [['restaurant', 'cafe', 'bakery'],   ['bar', 'ice_cream_shop', 'food_court']],
  nature:    [['park', 'hiking_area', 'beach'],   ['campground', 'botanical_garden', 'national_park']],
  adventure: [['climbing_gym', 'bowling_alley'],  ['amusement_park', 'sports_complex', 'go_kart']],
  funny:     [['comedy_club', 'escape_room'],     ['amusement_center', 'karaoke', 'miniature_golf']],
  loud:      [['night_club', 'live_music_venue'], ['bar', 'dance_hall', 'event_venue']],
}

const FIELDS = [
  'places.id',
  'places.displayName',
  'places.rating',
  'places.location',
  'places.regularOpeningHours',
  'places.primaryTypeDisplayName',
].join(',')

async function fetchPlaces(
  types: string[],
  lat: number,
  lng: number,
  radius: number,
  apiKey: string,
): Promise<Record<string, unknown>[]> {
  const res = await fetch('https://places.googleapis.com/v1/places:searchNearby', {
    method: 'POST',
    headers: {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': FIELDS,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      includedTypes: types,
      maxResultCount: 20,
      languageCode: 'he',
      locationRestriction: {
        circle: { center: { latitude: lat, longitude: lng }, radius: radius },
      },
      rankPreference: 'POPULARITY',
    }),
  })
  if (!res.ok) throw new Error(`Google Places error: ${await res.text()}`)
  const { places = [] } = await res.json()
  return places as Record<string, unknown>[]
}

function scorePlace(
  p: Record<string, unknown>,
  lat: number,
  lng: number,
  radius: number,
  vibe: string,
  city: string,
) {
  const pLat = (p.location as { latitude: number }).latitude
  const pLng = (p.location as { longitude: number }).longitude
  const distKm = Math.sqrt(Math.pow(pLat - lat, 2) + Math.pow(pLng - lng, 2)) * 111
  const distanceScore = Math.max(0, 1 - distKm / (radius / 1000))
  const rating = (p.rating as number) ?? 0
  // score = (rating × 0.4) + (vibe_match=1.0 × 0.4) + (distance × 0.2)
  const score = rating * 0.4 + 1.0 * 0.4 + distanceScore * 0.2

  return {
    google_place_id: p.id as string,
    name: (p.displayName as { text: string })?.text ?? '',
    vibe,
    city,
    lat: pLat,
    lng: pLng,
    google_rating: rating,
    score: Math.round(score * 100) / 100,
    opening_hours: p.regularOpeningHours ?? null,
    type: 'place',
    event_date: null,
    last_validated_at: new Date().toISOString(),
  }
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { city, vibe, lat, lng, radius } = await req.json() as {
      city: string; vibe: string; lat: number; lng: number; radius: number
    }

    if (!city || !vibe || lat == null || lng == null || !radius) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields: city, vibe, lat, lng, radius' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    const PLACES_KEY = Deno.env.get('GOOGLE_PLACES_KEY')
    if (!PLACES_KEY) throw new Error('GOOGLE_PLACES_KEY secret not set')

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    )

    // בדוק אם יש נתונים טריים (עד שבוע) — אם כן, החזר מ-DB ישירות
    const oneWeekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString()
    const { data: freshCheck } = await supabase
      .from('events')
      .select('id')
      .eq('city', city)
      .eq('vibe', vibe)
      .eq('type', 'place')
      .gte('last_validated_at', oneWeekAgo)
      .limit(1)

    if (freshCheck && freshCheck.length > 0) {
      const { data: cached } = await supabase
        .from('events')
        .select('*')
        .eq('city', city)
        .eq('vibe', vibe)
        .order('score', { ascending: false })
        .limit(5)
      return new Response(
        JSON.stringify({ events: cached ?? [], source: 'cache' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      )
    }

    // 2 קריאות מקבילות ל-Google Places → עד 30 תוצאות ייחודיות
    const [typesA, typesB] = VIBE_TYPES[vibe] ?? [['restaurant'], ['cafe']]
    const [batchA, batchB] = await Promise.all([
      fetchPlaces(typesA, lat, lng, radius, PLACES_KEY),
      fetchPlaces(typesB, lat, lng, radius, PLACES_KEY),
    ])

    // מיזוג + הסרת כפילויות לפי google place id
    const seen = new Set<string>()
    const merged = [...batchA, ...batchB].filter((p) => {
      const id = p.id as string
      if (seen.has(id)) return false
      seen.add(id)
      return true
    })

    // סינון rating >= 4.0 + ציון + מיון
    const scored = merged
      .filter((p) => ((p.rating as number) ?? 0) >= 4.0)
      .map((p) => scorePlace(p, lat, lng, radius, vibe, city))
      .sort((a, b) => b.score - a.score)
      .slice(0, 30)

    // שמור ל-DB
    if (scored.length > 0) {
      const { error: upsertErr } = await supabase
        .from('events')
        .upsert(scored, { onConflict: 'google_place_id' })
      if (upsertErr) throw new Error(`DB upsert failed: ${upsertErr.message}`)
    }

    return new Response(
      JSON.stringify({ events: scored.slice(0, 5), source: 'google_places' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (err) {
    const message = err instanceof Error ? err.message : String(err)
    return new Response(
      JSON.stringify({ error: message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  }
})
