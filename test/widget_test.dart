import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
