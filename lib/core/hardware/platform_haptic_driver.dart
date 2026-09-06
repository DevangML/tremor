import 'package:flutter/services.dart';
import 'package:tremor/core/hardware/haptic_gateway.dart';

final class PlatformHapticDriver implements HapticGateway {
  const new();

  @override
  Future<void> triggerSevereAlertHaptic() async {
    await HapticFeedback.heavyImpact();
  }
}
