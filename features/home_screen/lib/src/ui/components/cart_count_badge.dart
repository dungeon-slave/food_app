import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart' show AppDimens, AppFonts;
import 'package:flutter/material.dart';
import 'package:home_screen/src/bloc/home_screen_bloc.dart';

class CartCountBadge extends StatelessWidget {
  final Icon _themeIcon;

  const CartCountBadge({
    required Icon themeIcon,
    super.key,
  }) : _themeIcon = themeIcon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (BuildContext context, HomeScreenState state) {
        return Badge(
          offset: const Offset(
            AppDimens.margin5,
            -AppDimens.margin5,
          ),
          isLabelVisible: state.count != 0,
          label: Text(
            state.count.toString(),
            style: AppFonts.bold10.copyWith(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          child: _themeIcon,
        );
      },
    );
  }
}
