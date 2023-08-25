import 'package:data/entities/dish_entity/dish_entity.dart';
import 'package:data/mappers/dish_mapper.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'DishMapper',
    () {
      const DishEntity validEntity = DishEntity(
        imageRef: '1',
        name: '1',
        description: '1',
        price: 1.00,
        ingredients: <String>[],
        id: '1',
      );
      const DishModel validModel = DishModel(
        imageRef: '1',
        name: '1',
        description: '1',
        price: 1.00,
        ingredients: <String>[],
        id: '1',
      );

      test(
        'Check toModel method on valid data',
        () {
          final DishModel result = DishMapper.toModel(validEntity);
          expect(validModel.imageRef, result.imageRef);
          expect(validModel.name, result.name);
          expect(validModel.description, result.description);
          expect(validModel.price, result.price);
          expect(validModel.ingredients, result.ingredients);
          expect(validModel.id, result.id);
        },
      );

      test(
        'Check toEntity method on valid data',
        () {
          final DishEntity result = DishMapper.toEntity(validModel);
          expect(validEntity.imageRef, result.imageRef);
          expect(validEntity.name, result.name);
          expect(validEntity.description, result.description);
          expect(validEntity.price, result.price);
          expect(validEntity.ingredients, result.ingredients);
          expect(validEntity.id, result.id);
        },
      );
    },
  );
}
