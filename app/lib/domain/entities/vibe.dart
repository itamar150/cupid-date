import 'package:flutter/material.dart';

enum Vibe { calm, food, nature, adventure, funny, loud }

extension VibeInfo on Vibe {
  String get label => const {
    Vibe.calm: 'רגוע',
    Vibe.food: 'אוכל',
    Vibe.nature: 'טבע',
    Vibe.adventure: 'אתגרי',
    Vibe.funny: 'קומי',
    Vibe.loud: 'חיי לילה',
  }[this]!;

  // String get emoji => const {
  //   Vibe.calm: '🧘',
  //   Vibe.food: '🍽️',
  //   Vibe.nature: '🌿',
  //   Vibe.adventure: '🧗',
  //   Vibe.funny: '😂',
  //   Vibe.loud: '🎉',
  // }[this]!;

  Color get cardColor => const {
    Vibe.calm: Color(0xFFEDE5EC),
    Vibe.food: Color(0xFFF5E6D3),
    Vibe.nature: Color(0xFFD9EDD9),
    Vibe.adventure: Color(0xFFD3DCF0),
    Vibe.funny: Color(0xFFF5F0D0),
    Vibe.loud: Color.fromARGB(255, 207, 191, 226),
  }[this]!;

  String get imageAsset => const {
    Vibe.calm: 'assets/images/vibes/vibe_calm.jpg',
    Vibe.food: 'assets/images/vibes/vibe_food.jpg',
    Vibe.nature: 'assets/images/vibes/vibe_nature.jpg',
    Vibe.adventure: 'assets/images/vibes/vibe_adventure.jpg',
    Vibe.funny: 'assets/images/vibes/vibe_funny.jpg',
    Vibe.loud: 'assets/images/vibes/vibe_loud.jpg',
  }[this]!;

    String get imageAsset1 => const {
    Vibe.calm: 'assets/images/vibes/vibe_calm.png',
    Vibe.food: 'assets/images/vibes/vibe_food.png',
    Vibe.nature: 'assets/images/vibes/vibe_nature.png',
    Vibe.adventure: 'assets/images/vibes/vibe_adventure.png',
    Vibe.funny: 'assets/images/vibes/vibe_funny.png',
    Vibe.loud: 'assets/images/vibes/vibe_loud.png',
  }[this]!;
}

const hangToVibes = <String, List<Vibe>>{
  'טיול': [Vibe.nature],
  'מסעדה / קפה': [Vibe.food],
  'ספא': [Vibe.calm],
  'הופעות': [Vibe.loud],
  'קולנוע': [Vibe.calm],
  'טיפוס קיר': [Vibe.adventure],
  'ריקוד': [Vibe.loud],
  'סדנאות': [Vibe.calm],
  'בר': [Vibe.food, Vibe.loud],
  'מוזיאון': [Vibe.calm],
  'חדר בריחה': [Vibe.adventure, Vibe.funny],
  'מסיבות': [Vibe.loud],
  'קמפינג': [Vibe.nature],
  'סטנדאפ': [Vibe.funny],
};
