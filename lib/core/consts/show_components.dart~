import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/business/app_cubit.dart';
import 'package:prods/core/business/app_state.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/widgets_components.dart';

class AppDialogs {
  showFilterByTime(BuildContext mainContext, Timestamp from, Timestamp to, Function onClick,) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AppCubit cubit = AppCubit.get(mainContext);

    bool areYouInFrom = true;

    cubit.goToAppStateInitialState();

    TextEditingController dayController = TextEditingController()..text =  from.toDate().day.toString();
    TextEditingController monthController = TextEditingController()..text = from.toDate().month.toString();
    TextEditingController yearController = TextEditingController()..text = from.toDate().year.toString();

    showDialog(
        context: mainContext,
        barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
        builder: (BuildContext context) {
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
                    const Expanded(child: Text(textAlign: TextAlign.end ,"تصفية بالتاريخ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  ],
                )),
            content: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BlocBuilder<AppCubit, AppState>(
                                buildWhen: (previous, current) => current is ChangeBetweenFromAndToTime,
                                builder: (context, state) {
                                  Color bgColor = AppColors.appGreenColor;
                                  if(state is ChangeBetweenFromAndToTime && !state.areYouInFrom){
                                    bgColor = AppColors.appGrey;
                                  }
                                  return getAppButton(color: bgColor, textColor: Colors.black, text: "من", onClick: (){
                                    if(!areYouInFrom){
                                      areYouInFrom = true;
                                      cubit.changeBetweenFromAndToTime(areYouInFrom);

                                      cubit.appActions.setTemporaryTimeTo(Timestamp.fromDate(
                                          DateTime(
                                              int.parse(yearController.text),
                                              int.parse(monthController.text),
                                              int.parse(dayController.text))
                                      ));

                                      dayController.text =  cubit.appActions.getTemporaryTimeFrom().toDate().day.toString();
                                      monthController.text = cubit.appActions.getTemporaryTimeFrom().toDate().month.toString();
                                      yearController.text = cubit.appActions.getTemporaryTimeFrom().toDate().year.toString();
                                    }
                                  });
                                },
                              ),
                              BlocBuilder<AppCubit, AppState>(
                                buildWhen: (previous, current) => current is ChangeBetweenFromAndToTime,
                                builder: (context, state) {
                                  Color bgColor = AppColors.appGrey;
                                  if(state is ChangeBetweenFromAndToTime && ! state.areYouInFrom){
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: bgColor, textColor: Colors.black, text: "إلى", onClick: (){
                                    if(areYouInFrom){
                                      areYouInFrom = false;
                                      cubit.changeBetweenFromAndToTime(areYouInFrom);

                                      cubit.appActions.setTemporaryTimeFrom(Timestamp.fromDate(
                                          DateTime(
                                              int.parse(yearController.text),
                                              int.parse(monthController.text),
                                              int.parse(dayController.text))
                                      ));

                                      dayController.text =  cubit.appActions.getTemporaryTimeTo().toDate().day.toString();
                                      monthController.text = cubit.appActions.getTemporaryTimeTo().toDate().month.toString();
                                      yearController.text = cubit.appActions.getTemporaryTimeTo().toDate().year.toString();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: SizedBox(
                            width: 260,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 80,
                                    child: getAppTextField(text: "اليوم", inputType: TextInputType.number, onChange: (value){
                                      if (!RegExp(r'^\d*$').hasMatch(value)) {
                                        dayController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                                        dayController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: dayController.text.length),
                                        );
                                      }
                                    }, validator: (value){}, controller: dayController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,

                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          if (newValue.text.isEmpty) {
                                            return newValue;
                                          }
                                          final intValue = int.tryParse(newValue.text);
                                          if (intValue != null && intValue <= 31 && intValue >= 1) {
                                            return newValue;
                                          }
                                          return oldValue;
                                        }),
                                      ],
                                    )),
                                SizedBox(
                                    width: 80,
                                    child: getAppTextField(text: "الشهر", inputType: TextInputType.number, onChange: (value){
                                      if (!RegExp(r'^\d*$').hasMatch(value)) {
                                        monthController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                                        monthController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: monthController.text.length),
                                        );
                                      }
                                    }, validator: (value){}, controller: monthController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          if (newValue.text.isEmpty) {
                                            return newValue;
                                          }
                                          final intValue = int.tryParse(newValue.text);
                                          if (intValue != null && intValue <= 12 && intValue >= 1) {
                                            return newValue;
                                          }
                                          return oldValue;
                                        }),
                                      ],
                                    )),
                                SizedBox(
                                    width: 80,
                                    child: getAppTextField(text: "السنة", inputType: TextInputType.number, onChange: (value){}, validator: (value){
                                      if(value.toString().isEmpty || value == null){
                                        return "";
                                      }
                                      if(int.parse(value.toString()) < 2024){
                                        return "2023+";
                                      }
                                      return null;
                                    }, controller: yearController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          if (newValue.text.isEmpty) {
                                            return newValue;
                                          }
                                          final intValue = int.tryParse(newValue.text);
                                          if (intValue != null && intValue <= DateTime.now().year) {
                                            return newValue;
                                          }
                                          return oldValue;
                                        }),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: getAppButton(color: AppColors.appLightBlueColor, textColor: Colors.black, text: "حفظ التغييرات", onClick: (){
                              if(formKey.currentState!.validate()){
                                if(areYouInFrom){
                                  cubit.appActions.setTemporaryTimeFrom(Timestamp.fromDate(
                                      DateTime(
                                          int.parse(yearController.text),
                                          int.parse(monthController.text),
                                          int.parse(dayController.text))
                                  ));
                                }else{
                                  cubit.appActions.setTemporaryTimeTo(Timestamp.fromDate(
                                      DateTime(
                                          int.parse(yearController.text),
                                          int.parse(monthController.text),
                                          int.parse(dayController.text))
                                  ));
                                }

                                onClick();

                                Navigator.pop(context);
                              }}
                            ))
                      ],
                    ),
                  ),
                )
            ),
          );
        }
    );
  }
}