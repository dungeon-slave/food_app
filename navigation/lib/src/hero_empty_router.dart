import 'package:core/core.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'EmptyDishesMenu')
class HeroEmptyRouterPage extends StatelessWidget {
  const HeroEmptyRouterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HeroControllerScope(
      controller: HeroController(),
      child: const AutoRouter(),
    );
  }
}
