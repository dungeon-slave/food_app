import 'package:domain/models/order_history/order_model.dart';
import 'package:domain/repositories/order_history_repository.dart';
import 'package:domain/usecase/order_history/fetch_order_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:order_history/order_history.dart';

void main() {
  const OrderHistoryState validState = OrderHistoryState(items: <OrderModel>[]);
  final OrderHistoryBloc bloc = OrderHistoryBloc(
    fetchOrderHistoryUseCase: FetchOrderHistoryUseCase(
      orderHistoryRepository: _OrderHistoryRepositoryTest(),
    ),
  );

  group(
    'HomeScreenBloc',
    () {
      test(
        'Check init state results',
        () {
          bloc.add(InitEvent());
          expect(bloc.state.items, validState.items);
        },
      );
    },
  );
}

class _OrderHistoryRepositoryTest implements OrderHistoryRepository {
  @override
  Future<List<OrderModel>> fetchOrderHistory() => Future(() => <OrderModel>[]);
}
