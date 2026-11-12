import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Keeps custom controls clear of Android's edge-to-edge system navigation.
class AppViewport extends StatelessWidget {
  const AppViewport({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // App bars already handle the top status-bar inset.
      return SafeArea(top: false, child: child);
    }
    return child;
  }
}
