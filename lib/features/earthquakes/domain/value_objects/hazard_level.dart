extension type const HazardLevel(int score) implements int {
  /// Factory method to evaluate risk score; extension types do not support
  /// unnamed factory constructors redirecting to representation types.
  // ignore: prefer_constructors_over_static_methods
  static HazardLevel fromSeismicData({
    required double mag,
    required double depthKm,
  }) {
    if (mag >= 7.0 && depthKm <= 50.0) {
      return const HazardLevel(4);
    }
    if (mag >= 6.0 && depthKm <= 50.0) {
      return const HazardLevel(3);
    }
    if (mag >= 4.0) {
      return const HazardLevel(2);
    }
    return const HazardLevel(1);
  }

  bool get isTsunamiRisk => score >= 3;
  bool get isStructuralRisk => score >= 3;

  String get severityLabel => switch (score) {
    1 => 'Low Risk',
    2 => 'Moderate Advisory',
    3 => 'High Alert',
    4 => 'Catastrophic Emergency',
    _ => 'Unclassified Risk',
  };

  static bool isValidScore(int val) => val >= 1 && val <= 4;
}
