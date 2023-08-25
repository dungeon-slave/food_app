library dishes_menu;

import 'package:core/core.dart';
import 'dishes_menu.gm.dart';

export 'src/ui/dishes_menu.dart';
export 'src/ui/dish_item.dart';
export 'src/bloc/bloc.dart';
export 'dishes_menu.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Screen,Route')
class DishesMenuModule extends $DishesMenuModule {}
