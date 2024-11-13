import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/sections/buys_cubit.dart';

import '../../../models/buy_model.dart';

showAddEditNewBuyOption(BuildContext mainContext, BuyModel? buyModel) {
  showDialog(
      context: mainContext,
      barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController buyPriceController = TextEditingController();
        TextEditingController sellPriceController = TextEditingController();
        TextEditingController quantityController = TextEditingController();
        TextEditingController unitController = TextEditingController();

        GlobalKey<FormState> formKey = GlobalKey<FormState>();

        void submit(){
          BuysCubit cubit = BuysCubit.get(mainContext);
          if(buyModel != null){
            cubit.editBuy(
                BuyModel(id: buyModel.id, name: nameController.text, unit: unitController.text, quantity: double.parse(quantityController.text.toString()), priceOfBuy: double.parse(buyPriceController.text.toString()), priceOfSell: double.parse(sellPriceController.text.toString()), createdAt: buyModel.createdAt, updatedAt: Timestamp.now()),
                );
          }
          else{
            cubit.addNewBuy(
              BuyModel(id: "", name: nameController.text, unit: unitController.text, quantity: double.parse(quantityController.text.toString()), priceOfBuy: double.parse(buyPriceController.text.toString()), priceOfSell: double.parse(sellPriceController.text.toString()), createdAt: Timestamp.now(), updatedAt: Timestamp.now()),
            );
          }
        }

        if(buyModel != null){
          nameController.text = buyModel.name;
          buyPriceController.text = buyModel.priceOfBuy.toString();
          sellPriceController.text = buyModel.priceOfSell.toString();
          quantityController.text = buyModel.quantity.toString();
          unitController.text = buyModel.unit;
        }

        return AlertDialog(
        backgroundColor: Colors.white,
        title: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
            Expanded(child: Text(buyModel == null ? "عملية شراء جديدة" : buyModel.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
          ],
        )
      ),
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                  getAppTextField(text: "الاسم", onChange: (value){}, validator: (value){
                    if(value == null || value.toString().isEmpty){
                      return "يجب أن تدخل اسم المنتج";
                    }
                  }, controller: nameController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.rtl, suffixIconButton: null,),

                  const SizedBox(height: 5,),

                  getAppTextField(text: "الوحدة", onChange: (value){}, validator: (value){
                    if(value == null || value.toString().isEmpty){
                      return "يجب أن تدخل وحدة المنتج";
                    }
                  }, controller: unitController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.rtl, suffixIconButton: null,),

                  const SizedBox(height: 5,),

                  getAppTextField(text: "الكمية", onChange: (value){
                    quantityController.text = value.replaceAll(RegExp(r'[^0-9.]'), '');
                    quantityController.selection = TextSelection.fromPosition(
                    TextPosition(offset: quantityController.text.length),
                    );
                  }, validator: (value){
                    if(value == null || value.toString().isEmpty){
                      return "يجب أن تدخل كمية المنتج";
                    }
                  },
                    inputType: TextInputType.number,
                    controller: quantityController, fillColor: AppColors.appGrey,
                    obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,),
                  const SizedBox(height: 5,),
                  getAppTextField(text: "سعر الشراء",
                    inputType: TextInputType.number, onChange: (value){
                    if (!RegExp(r'^\d*$').hasMatch(value)) {
                      buyPriceController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                      buyPriceController.selection = TextSelection.fromPosition(
                        TextPosition(offset: buyPriceController.text.length),
                      );
                    }
                  }, validator: (value){
                    if(value == null || value.toString().isEmpty){
                      return "يجب أن تدخل سعر شراء المنتج";
                    }
                  }, controller: buyPriceController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,),
                  const SizedBox(height: 5,),
                  getAppTextField(text: "سعر البيع", onChange: (value){
                    if (!RegExp(r'^\d*$').hasMatch(value)) {
                      sellPriceController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                      sellPriceController.selection = TextSelection.fromPosition(
                        TextPosition(offset: sellPriceController.text.length),
                      );
                    }
                  },
                    inputType: TextInputType.number,
                    validator: (value){
                    if(value == null || value.toString().isEmpty){
                      return "يجب أن تدخل سعر بيع المنتج";
                    }
                    if(double.parse(value.toString()) < double.parse(buyPriceController.text)){
                      return "لا يمكن أن يكون سعر البيع أقل من الشراء";
                    }
                  }, controller: sellPriceController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,),
                  const SizedBox(height: 25,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: getAppButton(
                        text: buyModel == null ? "إضافة" : "حفظ التغييرات",
                        color: AppColors.appLightBlueColor,
                        textColor: Colors.black, onClick: (){
                          if(formKey.currentState!.validate()){
                            submit();
                            Navigator.of(context).pop();
                          }},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  });
}
