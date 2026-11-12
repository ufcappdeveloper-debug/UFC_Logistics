import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufc_delivery_app/components/app_viewport.dart';

void main() {
  Future<void> pumpViewport(
      WidgetTester tester, TargetPlatform platform, EdgeInsets insets) async {
    debugDefaultTargetPlatformOverride = platform;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: insets,
          viewPadding: insets,
        ),
        child: AppViewport(child: child!),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        bottomNavigationBar: const SizedBox(
          key: Key('bottom-controls'),
          height: 64,
        ),
      ),
    ));
    debugDefaultTargetPlatformOverride = null;
  }

  testWidgets('Android bottom controls avoid system navigation',
      (tester) async {
    await pumpViewport(tester, TargetPlatform.android,
        const EdgeInsets.only(top: 24, bottom: 48));
    final controls = tester.getRect(find.byKey(const Key('bottom-controls')));
    expect(controls.bottom, 600 - 48);
    expect(tester.getSize(find.byType(AppBar)).height, kToolbarHeight + 24);
  });

  testWidgets('Android landscape controls avoid side navigation',
      (tester) async {
    await pumpViewport(tester, TargetPlatform.android,
        const EdgeInsets.only(left: 24, right: 48));
    final controls = tester.getRect(find.byKey(const Key('bottom-controls')));
    expect(controls.left, 24);
    expect(controls.right, 800 - 48);
  });

  testWidgets('iOS keeps its existing viewport behavior', (tester) async {
    await pumpViewport(
        tester, TargetPlatform.iOS, const EdgeInsets.only(top: 44, bottom: 34));
    final controls = tester.getRect(find.byKey(const Key('bottom-controls')));
    expect(controls.bottom, 600);
  });
}
