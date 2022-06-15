import 'package:confluence_connect/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

AppBar appBarCustom({
  @required String title,
  Widget leading,
  double height,
  Color backgroundColor,
  Color color,
  List<Widget> actions,
}) {
  return AppBar(
    backgroundColor: backgroundColor ?? AppColors.primary,
    elevation: 0.0,
    leading: leading,
    titleSpacing: 0.0,
    title: Text(
      title,
      style: TextStyles.appBarTittle.copyWith(
        color: color ?? AppColors.white,
      ),
    ),
    centerTitle: true,
    actions: actions,
  );
}
