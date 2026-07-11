import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aura_mobile/main.dart';

void main() {
  testWidgets('AURA Mobile App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AuraMobileApp()));
    expect(find.text('Hedefin Ne?'), findsOneWidget);
  });
}
