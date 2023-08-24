library detailed_page;

import 'package:core/core.dart';

export 'src/ui/detailed_page.dart';

import 'detailed_page.gm.dart';
export 'detailed_page.gm.dart';

@AutoRouterConfig.module(replaceInRouteName: 'Screen,Route')
class DetailedPageModule extends $DetailedPageModule {}
