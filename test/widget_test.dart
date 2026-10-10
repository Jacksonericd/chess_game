import 'package:flutter_test/flutter_test.dart';
import 'package:chess_app/main.dart';

void main() {
  testWidgets('renders the chess board', (tester) async {
    await tester.pumpWidget(const ChessApp());
    expect(find.text('CHESS'), findsOneWidget);
    expect(find.text('White to move'), findsOneWidget);
  });
}
