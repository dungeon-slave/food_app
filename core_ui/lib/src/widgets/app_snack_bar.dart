import 'package:core_ui/src/theme/app_dimens.dart';
import 'package:core_ui/src/theme/app_num_constants.dart';
import 'package:core_ui/src/theme/fonts.dart';
import 'package:flutter/material.dart';

void showAppSnackBar({
  required BuildContext context,
  required String title,
  EdgeInsets? snackMargin,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: AppNumConstants.cartSnackBarDuration,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).indicatorColor,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radius10),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        margin: snackMargin,
        content: Center(
          child: Text(
            title,
            style: AppFonts.normal22.copyWith(
              color: Theme.of(context).indicatorColor,
            ),
          ),
        ),
      ),
    );
}
