import 'package:core/core.dart'
    show
        AutoTabsScaffold,
        Bloc,
        BlocBuilder,
        BlocProvider,
        PageRouteInfo,
        RoutePage,
        TabsRouter;
import 'package:core/di/app_di.dart';
import 'package:core/services/network_service.dart';
import 'package:core_ui/core_ui.dart'
    show AppIcon, AppIconsData, AppNumConstants, AppStrConstants;
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:home_screen/src/bloc/cart_observer.dart';
import 'package:home_screen/src/bloc/home_screen_bloc.dart';
import 'package:home_screen/src/ui/components/cart_count_badge.dart';
import 'package:home_screen/src/ui/components/network_popup.dart';
import 'package:navigation/navigation.dart' show EmptyDishesMenu;
import 'package:order_history/order_history.dart';
import 'package:settings/settings.dart';
import 'package:shopping_cart/shopping_cart.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeScreenBloc(
        fetchCartCountUseCase: appLocator<FetchCartCountUseCase>(),
        networkService: appLocator<NetworkService>(),
        fetchTextScaleUseCase: appLocator<FetchTextScaleUseCase>(),
        fetchThemeUseCase: appLocator<FetchThemeUseCase>(),
      ),
      child: Stack(
        children: <Widget>[
          AutoTabsScaffold(
            routes: const <PageRouteInfo>[
              EmptyDishesMenu(),
              OrderHistoryRoute(),
              ShoppingCartRoute(),
              SettingsRoute(),
            ],
            animationCurve: Curves.linear,
            animationDuration: const Duration(
              milliseconds: AppNumConstants.mainDuration,
            ),
            transitionBuilder: (
              BuildContext context,
              Widget child,
              Animation<double> animation,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            bottomNavigationBuilder: (BuildContext context, TabsRouter router) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).indicatorColor),
                  ),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  currentIndex: router.activeIndex,
                  onTap: router.setActiveIndex,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).indicatorColor,
                  unselectedItemColor: Theme.of(context).indicatorColor,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      activeIcon: AppIcon(AppIconsData.selectedMenu),
                      icon: AppIcon(AppIconsData.unselectedMenu),
                      label: AppStrConstants.menuTitle,
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppIcon(AppIconsData.selectedOrderHistory),
                      icon: AppIcon(AppIconsData.unselectedOrderHistory),
                      label: AppStrConstants.orderHistoryTitle,
                    ),
                    BottomNavigationBarItem(
                      activeIcon: CartCountBadge(
                        themeIcon: AppIcon(
                          AppIconsData.selectedShoppingCart,
                        ),
                      ),
                      icon: CartCountBadge(
                        themeIcon: AppIcon(
                          AppIconsData.unselectedShoppingCart,
                        ),
                      ),
                      label: AppStrConstants.shoppingCartTitle,
                    ),
                    BottomNavigationBarItem(
                      activeIcon: AppIcon(AppIconsData.selectedSettings),
                      icon: AppIcon(AppIconsData.unselectedSettings),
                      label: AppStrConstants.settingsTitle,
                    ),
                  ],
                ),
              );
            },
          ),
          BlocBuilder<HomeScreenBloc, HomeScreenState>(
            builder: (BuildContext context, HomeScreenState state) {
              Bloc.observer = CartObserver(context: context);
              if (state.isVisibleMessage) {
                return NetworkPopUp(isConnected: state.isConnected);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
