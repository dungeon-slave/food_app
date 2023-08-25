import 'package:domain/models/cart_items/cart_item_model.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:flutter/material.dart' show Key, MaterialApp, Scaffold;
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/shopping_cart.dart';

void main() {
  const Key widgetKey = Key('cartItem');
  final CartItemModel model = CartItemModel(
    dishModel: const DishModel(
      imageRef: '',
      name: '',
      price: 0.00,
      description: '',
      ingredients: <String>[],
      id: '',
    ),
    count: 0,
  );

  testWidgets(
    'Check correct CartItem building',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CartItem(
              model: model,
              key: widgetKey,
            ),
          ),
        ),
      );

      expect(find.byKey(widgetKey), findsOneWidget);
    },
  );
}
