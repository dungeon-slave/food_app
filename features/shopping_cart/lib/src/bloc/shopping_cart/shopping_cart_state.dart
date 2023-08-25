part of 'shopping_cart_bloc.dart';

class ShoppingCartState {
  final bool isLoading;
  final String errorMessage;
  final List<CartItemModel> items;
  final bool isOrdered;

  const ShoppingCartState({
    this.isLoading = false,
    this.isOrdered = false,
    this.errorMessage = '',
    required this.items,
  });

  double totalPrice() {
    double total = 0;
    for (CartItemModel item in items) {
      total += item.averagePrice;
    }

    return total;
  }

  ShoppingCartState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CartItemModel>? items,
    bool? isOrdered,
  }) {
    return ShoppingCartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      items: items ?? this.items,
      isOrdered: isOrdered ?? this.isOrdered,
    );
  }
}
