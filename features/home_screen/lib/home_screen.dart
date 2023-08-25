library home_screen;

import 'package:core/core.dart';
import 'home_screen.gm.dart';

export 'src/ui/home_screen.dart';
export 'home_screen.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Screen,Route')
class HomeScreenModule extends $HomeScreenModule {}
