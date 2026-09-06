extension type const Magnitude(double value) implements double {
  bool get isSevere => value >= 5.0;
  bool get isMicro => value < 2.0;

  static bool isValid(double val) => val >= 0.0 && val <= 10.0;
}
