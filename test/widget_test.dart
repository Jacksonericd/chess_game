import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_app/main.dart';

void main() {
  testWidgets('setup screen fits common portrait and landscape sizes', (
    tester,
  ) async {
    final view = tester.view;
    view.devicePixelRatio = 1;
    for (final size in [
      const Size(320, 568),
      const Size(390, 844),
      const Size(667, 375),
      const Size(1024, 768),
    ]) {
      view.physicalSize = size;
      await tester.pumpWidget(ChessApp(key: ValueKey(size)));
      await tester.pumpAndSettle();

      expect(find.text('Choose your opponent\'s difficulty'), findsOneWidget);
      expect(find.text('START GAME'), findsOneWidget);
      expect(
        tester.getRect(find.text('START GAME')).bottom,
        lessThanOrEqualTo(size.height),
      );
      await tester.tap(find.text('START GAME'));
      await tester.pumpAndSettle();
      expect(find.text('UNDO'), findsOneWidget);
      expect(find.text('ROTATE'), findsOneWidget);
      final rook = tester.widget<Text>(
        find
            .byWidgetPredicate(
              (widget) =>
                  widget is Text && widget.data?.startsWith('♜') == true,
            )
            .first,
      );
      expect(rook.style?.fontSize, greaterThan(20));
      expect(tester.takeException(), isNull);
    }
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });
}
