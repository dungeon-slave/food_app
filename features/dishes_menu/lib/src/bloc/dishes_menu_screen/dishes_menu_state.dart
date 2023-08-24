part of 'dishes_menu_bloc.dart';

class MenuState {
  final List<DishTypeModel> items;
  final bool isLoading;
  final String errorMessage;
  final int currentTab;

  const MenuState({
    required this.items,
    this.isLoading = false,
    this.errorMessage = '',
    this.currentTab = 0,
  });

  MenuState copyWith({
    List<DishTypeModel>? items,
    bool? isLoading,
    String? errorMessage,
    int? currentTab,
  }) {
    return MenuState(
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}
