import 'package:core/core.dart';
import 'package:core/di/app_di.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/models/order_history/order_model.dart';
import 'package:domain/usecase/order_history/fetch_order_history.dart';
import 'package:flutter/material.dart';
import 'package:order_history/src/bloc/order_history_bloc.dart';
import 'package:order_history/src/ui/components/order_history_item.dart';

@RoutePage()
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OrderHistoryBloc(
        fetchOrderHistoryUseCase: appLocator<FetchOrderHistoryUseCase>(),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SafeArea(
            minimum: EdgeInsets.only(top: constraints.minHeight / 28),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  AppStrConstants.orderHistoryTitle,
                  style: AppFonts.normal30.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
                builder: (BuildContext context, OrderHistoryState state) {
                  if (state.isLoading) {
                    return const AppLoadingCircle();
                  }
                  if (state.errorMessage.isNotEmpty) {
                    return AppError(errorText: state.errorMessage);
                  }
                  if (state.items.isEmpty) {
                    return const EmptyList(link: AppAnimations.emptyList);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(AppDimens.padding10),
                    itemCount: state.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return OrderHistoryItem(
                        model: OrderModel(
                          id: state.items[index].id,
                          dateTime: state.items[index].dateTime,
                          price: state.items[index].price,
                          products: state.items[index].products,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
