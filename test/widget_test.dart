import 'package:flutter_test/flutter_test.dart';
import 'package:test_1/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(isLoggedIn: false));
    expect(find.byType(MyApp), findsOneWidget);
  });
}
