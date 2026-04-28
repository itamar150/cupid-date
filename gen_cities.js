const fs = require('fs');
const data = JSON.parse(fs.readFileSync('cities.json', 'utf8'));
const cities = [...new Set(
  data.map(r => r['שם_ישוב'].trim())
      .filter(n => n.length > 0)
)].sort();

let dart = 'abstract final class IsraeliCities {\n  static const List<String> all = [\n';
for (const city of cities) {
  // Replace ASCII apostrophe (U+0027) with Hebrew Geresh (U+05F3)
  // to avoid breaking Dart single-quoted strings
  const safe = city.replace(/'/g, '׳');
  dart += `    '${safe}',\n`;
}
dart += '  ];\n}\n';

fs.writeFileSync('app/lib/core/data/israeli_cities.dart', dart, 'utf8');
console.log('Done!', cities.length, 'cities written.');
