enum Gender {
  male(1),
  female(2),
  other(3);

  const Gender(this.value);
  final int value;

  bool get isFeminine => this == Gender.female;

  String text(String masc, String fem) => isFeminine ? fem : masc;

  static Gender fromValue(int v) => Gender.values.firstWhere(
        (g) => g.value == v,
        orElse: () => Gender.male,
      );
}
