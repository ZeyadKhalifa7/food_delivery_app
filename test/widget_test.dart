import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('App launches and shows menu screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    expect(find.text('Delicious Bites'), findsOneWidget);
  });
}