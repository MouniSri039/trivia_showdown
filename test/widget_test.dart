
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_showdown/main.dart';

void main() {
  testWidgets('Trivia Showdown app displays its title', (tester) async {
    await tester.pumpWidget(const TriviaShowdownApp());

    expect(
      find.text('Cloud Trivia Showdown: API Edition'),
      findsOneWidget,
    );
  });
}
