import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

void main() {
  late final MockFirestore instance;
  late final MockCollectionReference reference;
  const String collectionRef = 'dishes-menu';

  setUp(
    () {
      instance = MockFirestore();
      reference = MockCollectionReference();
    },
  );

  test(
    'Check collection return',
    () {
      when(() => instance.collection(collectionRef)).thenReturn(reference);
      CollectionReference<Map<String, dynamic>> result =
          instance.collection(collectionRef);
      expect(result, isNotNull);
    },
  );
}
