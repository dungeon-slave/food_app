import 'package:core/core.dart' show BlocBuilder, BlocProvider, RoutePage;
import 'package:core/di/app_di.dart';
import 'package:core_ui/core_ui.dart';
import 'package:domain/domain.dart';
import 'package:domain/usecase/shopping_cart/send_order_usecase.dart';
import 'package:flutter/material.dart';
import 'package:shopping_cart/src/bloc/shopping_cart/shopping_cart_bloc.dart';
import 'package:shopping_cart/src/ui/cart_item.dart';

@RoutePage()
class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShoppingCartBloc(
        fetchItemsUseCase: appLocator<FetchItemsUseCase>(),
        changeItemCountUseCase: appLocator<ChangeItemCountUseCase>(),
        clearCartUseCase: appLocator<ClearCartUseCase>(),
        sendOrderUseCase: appLocator<SendOrderUseCase>(),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SafeArea(
            minimum: EdgeInsets.only(top: constraints.minHeight / 28),
            child: Scaffold(
              appBar: AppBar(
                actions: <Container>[
                  Container(
                    margin: const EdgeInsets.only(right: AppDimens.padding10),
                    child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                      builder: (BuildContext context, ShoppingCartState state) {
                        return IconButton(
                          iconSize: AppNumConstants.deleteIconSize,
                          icon: const AppIcon(AppIconsData.clearCart),
                          onPressed: () =>
                              BlocProvider.of<ShoppingCartBloc>(context).add(
                            ClearCartEvent(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                iconTheme: Theme.of(context).iconTheme,
                centerTitle: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  AppStrConstants.shoppingCartTitle,
                  style: AppFonts.normal30.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              body: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                builder: (BuildContext context, ShoppingCartState state) {
                  if (state.isLoading) {
                    return const AppLoadingCircle();
                  }
                  if (state.errorMessage.isNotEmpty) {
                    return AppError(errorText: state.errorMessage);
                  }
                  if (state.items.isEmpty) {
                    return EmptyList(
                      margin: EdgeInsets.only(
                        bottom: constraints.minHeight / 8,
                      ),
                      link: state.isOrdered
                          ? AppAnimations.ordered
                          : AppAnimations.emptyList,
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppDimens.padding100),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppDimens.padding10),
                      itemCount: state.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CartItem(
                          model: state.items[index],
                        );
                      },
                    ),
                  );
                },
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.all(AppDimens.padding10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).indicatorColor),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          AppStrConstants.total,
                          style: AppFonts.normal22,
                        ),
                        BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                          builder:
                              (BuildContext context, ShoppingCartState state) {
                            return Text(
                              '${state.totalPrice().toStringAsFixed(AppNumConstants.priceSize)}\$',
                              style: AppFonts.normal22,
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: constraints.minWidth,
                      child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                        builder: (
                          BuildContext context,
                          ShoppingCartState state,
                        ) {
                          return AppButton(
                            text: AppStrConstants.cartCheckout,
                            handler: () {
                              if (state.items.isNotEmpty) {
                                BlocProvider.of<ShoppingCartBloc>(context).add(
                                  CheckoutEvent(),
                                );
                              }
                              showAppSnackBar(
                                context: context,
                                title: state.items.isNotEmpty
                                    ? AppStrConstants.orderSent
                                    : AppStrConstants.emptyOrder,
                                snackMargin: EdgeInsets.only(
                                  left: constraints.minWidth / 40,
                                  right: constraints.minWidth / 40,
                                  bottom: constraints.minHeight / 7.5,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
