import 'package:dishes_menu/dishes_menu.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:flutter/material.dart' show Key, MaterialApp, Scaffold;
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Key widgetKey = Key('dishItem');
  const DishModel model = DishModel(
    imageRef: '',
    name: '',
    price: 0.00,
    description: '',
    ingredients: <String>[],
    id: '',
  );

  testWidgets(
    'Check correct DishItem building',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DishItem(
              model: model,
              key: widgetKey,
              handler: (Offset childOffset) {},
            ),
          ),
        ),
      );

      expect(find.byKey(widgetKey), findsOneWidget);
    },
  );
}
