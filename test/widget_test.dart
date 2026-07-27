import 'package:flutter_test/flutter_test.dart';
import 'package:watch_hub/main.dart';

void main() {
  testWidgets('WatchHub app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WatchHubApp());
    expect(find.text('WATCHHUB'), findsOneWidget);
  });
}
