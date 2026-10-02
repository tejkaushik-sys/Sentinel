import 'package:flutter_test/flutter_test.dart';
import 'package:sentinel_app/main.dart';

void main() {
  testWidgets('SentinelApp boots with SplashScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const SentinelApp());
    expect(find.text('SENTINEL'), findsOneWidget);
    expect(find.text('Know. Verify. Decide.'), findsOneWidget);
    
    // Pump through the splash screen timer and animations
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
