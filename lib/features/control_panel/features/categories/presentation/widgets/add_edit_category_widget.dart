import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

import '../../../../../../core/services/services_locator.dart';

class AddEditCategoryWidget extends StatelessWidget {
  final BuildContext context;
  final String message;
  final Color bkgColor;
  final Color textColor;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  const AddEditCategoryWidget({super.key,
        required this.context,
        required this.message,
        required this.bkgColor,
        required this.textColor,
        required this.controller,
        required this.formKey
      });

  @override
  Widget build(BuildContext context) {
    CategoriesCubit cubit = CategoriesCubit.get(context);
    CategoryModel? category;
    int? index;

    return BlocBuilder<CategoriesCubit, ControlPanelState>(
      buildWhen: (previous, current) => current is ChangeAddNewOrEditCategoryBoxState,
      builder: (context, state) {
        if(state is ! ChangeAddNewOrEditCategoryBoxState || ! state.isClickedOnAddNewCategory) {
          return Container();
        }

        category = state.category;
        if(category != null){
          controller.text = category!.name;
        }
        index = state.index;

        return Material(
          color: Colors.transparent,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: bkgColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(5, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    cubit.changeClickedOnAddNewOrEditCategory();
                  },
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(height: 10,),
                Text(
                  category == null ? "إضافة صنف جديد" : "تعديل '${category!.name}'",
                  style: const TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold,),),
                Form(
                  key: formKey,
                  child: getAppTextField(
                    text: "اسم الصنف",
                    onChange: (value) {},
                    validator: (value) {
                      if(value.toString().isEmpty || value == null){
                        return "يجب إدخال قيمة";
                      }
                      return null;
                    },
                    onSubmitted: (value){
                      if (formKey.currentState!.validate()) {
                        category == null
                            ? cubit.addNewCategory(controller.text.trim())
                            : cubit.editCategory(index!, CategoryModel(id: category!.id, name: controller.text.trim(), createdAt: category!.createdAt, updatedAt: Timestamp.now()));
                      }
                    },
                    controller: controller,
                    fillColor: AppColors.appGrey,
                    obscureText: false,
                    direction: TextDirection.rtl,
                    suffixIconButton: null,
                  ),
                ),
                const SizedBox(height: 20,),
                BlocConsumer<CategoriesCubit, ControlPanelState>(
                  listenWhen: (previous, current) => current is AddEditCategoryState && current.isLoaded,
                  buildWhen: (previous, current) => current is AddEditCategoryState,
                  builder: (context, state) {
                    if (state is AddEditCategoryState && !state.isLoaded) {
                      return getAppProgress();
                    }
                    return getAppButton(
                        color: AppColors.appGreenColor,
                        textColor: Colors.black,
                        text: category == null ? "إضافة" : "تعديل",
                        onClick: () {
                          if (formKey.currentState!.validate()) {
                            category == null
                                ? cubit.addNewCategory(controller.text.trim())
                                : cubit.editCategory(index!, CategoryModel(id: category!.id, name: controller.text.trim(), createdAt: category!.createdAt, updatedAt: Timestamp.now()));
                          }
                        },

                    );
                  },

                  listener: (BuildContext context, ControlPanelState state) {
                  if(state is AddEditCategoryState) {
                    if(state.isSuccess) {
                      sl<ShowCustomMessage>().showCustomToast(context: context, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.black,);
                      controller.text = "";
                    }else{
                      sl<ShowCustomMessage>().showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black,);
                    }
                  }
                },
                )
              ],
            ),
          ),
        ),
              );
  },
);
  }
}

