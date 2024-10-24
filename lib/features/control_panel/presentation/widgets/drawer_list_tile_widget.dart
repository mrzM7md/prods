import 'package:flutter/material.dart';

import '../../../../core/consts/app_colors.dart';
import '../../../../core/consts/app_images.dart';

class DrawerListTileWidget extends StatelessWidget {
  final String title, icon;
  final VoidCallback press;
  final Color? bgColor;
  final Color? color;
  const DrawerListTileWidget({super.key, required this.title, required this.icon, required this.bgColor, required this.press, this.color});
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: press,
      // focusColor: AppColors.appLightBlueColor,
      splashColor: AppColors.appLightBlueColor,
      borderRadius: BorderRadius.circular(11),
      focusColor: bgColor,
      hoverColor: AppColors.appLightBlueColor,
      // mouseCursor: MouseCursor.uncontrolled,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          color: bgColor
        ),
        child: ListTile(
          // hoverColor: AppColors.appLightBlueColor,
          // horizontalTitleGap: 0.0,
          leading: Image.asset(icon, height: 30,),
          contentPadding: const EdgeInsetsDirectional.all(5),
          // tileColor: AppColors.appLightBlueColor,
          title: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold), textAlign: TextAlign.center ,),
        ),
      ),
    );
  }
}
