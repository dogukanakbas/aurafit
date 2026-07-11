import 'package:flutter/material.dart';
import '../utils/haptic_feedback_helper.dart';

class HapticButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool isPrimary;

  const HapticButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    final handlePress = onPressed == null
        ? null
        : () async {
            await HapticHelper.triggerLightImpact();
            onPressed!();
          };

    return ElevatedButton(
      onPressed: handlePress,
      style: style,
      child: child,
    );
  }
}

/// Sayfalar arası geçişlerde otomatik olarak HapticFeedback.lightImpact() tetikleyen NavigatorObserver
class HapticNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    HapticHelper.triggerLightImpact();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    HapticHelper.triggerLightImpact();
  }
}
