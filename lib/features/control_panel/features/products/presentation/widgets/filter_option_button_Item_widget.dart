import 'package:flutter/material.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/business/sections/products_cubit.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

import '../../../../../../core/consts/app_colors.dart';

class FilterOptionButtonItemWidget extends StatelessWidget {
  const FilterOptionButtonItemWidget({super.key, required this.onClick, required this.text, required this.color, required this.bgColor});
  final VoidCallback onClick;
  final String text;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      color: bgColor,
      onPressed: onClick,
      hoverColor: AppColors.appGreenColor,
      child: Text(text, style: TextStyle(fontSize: 14, color: color),),);
  }
}
