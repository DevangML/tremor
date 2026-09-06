import 'package:flutter/material.dart';

final class TremorColors {
  const new _();

  static const Color low = Color(0xFF00BFA5); // Teal
  static const Color moderate = Color(0xFFFF9100); // Amber Orange
  static const Color severe = Color(0xFFFF1744); // Deep Alert Red
  static const Color background = Color(0xFF121212); // Dark Canvas

  static Color severityColor(double mag) => switch (mag) {
    < 3.0 => low,
    >= 3.0 && < 5.0 => moderate,
    _ => severe,
  };
}
