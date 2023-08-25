import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:detailed_page/detailed_page.dart';
import 'package:dishes_menu/dishes_menu.dart';
import 'package:home_screen/home_screen.dart';
import 'package:main_page_screen/main_page_screen.dart';
import 'package:navigation/src/app_router/auth_guard.dart';
import 'package:navigation/src/hero_empty_router.dart';
import 'package:order_history/order_history.dart';
import 'package:settings/settings.dart';
import 'package:shopping_cart/shopping_cart.dart';
import 'package:sign_in_screen/sign_in_screen.dart';
import 'package:sign_up_screen/sign_up_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  modules: <Type>[
    MainPageModule,
    HomeScreenModule,
    SignInModule,
    SignUpModule,
    DishesMenuModule,
    DetailedPageModule,
    OrderHistoryModule,
    ShoppingCartModule,
    SettingsModule,
  ],
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends _$AppRouter {
  final AuthGuard _authGuard;

  AppRouter({
    required AuthGuard authGuard,
  }) : _authGuard = authGuard;

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(
          path: '/',
          page: MainPageRoute.page,
          children: <AutoRoute>[
            AutoRoute(
              path: 'sign',
              page: EmptySign.page,
              children: <AutoRoute>[
                CustomRoute(
                  path: '',
                  page: SignInRoute.page,
                  durationInMilliseconds: AppNumConstants.nestedDuration,
                  transitionsBuilder: TransitionsBuilders.fadeIn,
                ),
                CustomRoute(
                  path: 'up',
                  page: SignUpRoute.page,
                  durationInMilliseconds: AppNumConstants.nestedDuration,
                  transitionsBuilder: TransitionsBuilders.fadeIn,
                ),
              ],
            ),
            AutoRoute(
              path: 'home',
              page: HomeRoute.page,
              initial: true,
              guards: <AutoRouteGuard>[_authGuard],
              children: <AutoRoute>[
                AutoRoute(
                  path: 'dishesMenu',
                  page: EmptyDishesMenu.page,
                  children: <AutoRoute>[
                    AutoRoute(
                      path: '',
                      page: DishesMenuRoute.page,
                    ),
                    AutoRoute(
                      page: DetailedPageRoute.page,
                      path: 'detailedPage',
                    ),
                  ],
                ),
                AutoRoute(
                  path: 'orderHistory',
                  page: OrderHistoryRoute.page,
                  maintainState: false,
                ),
                AutoRoute(
                  path: 'shoppingCart',
                  page: ShoppingCartRoute.page,
                  maintainState: false,
                ),
                AutoRoute(
                  path: 'settings',
                  page: SettingsRoute.page,
                ),
              ],
            ),
          ],
        ),
      ];
}
