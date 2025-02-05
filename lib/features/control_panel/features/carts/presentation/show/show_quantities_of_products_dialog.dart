import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';

void showCustomDialog(
    BuildContext mainContext, String id, String productName, double quantity, double selectedQuantity) {
  showDialog(
    context: mainContext,
    barrierDismissible: false, // منع الإغلاق عند الضغط خارج النافذة
    builder: (BuildContext context) {
      TextEditingController controller = TextEditingController();
      controller.text = "${selectedQuantity.toInt()}";

      ScrollController scrollInfoHorizontalController = ScrollController();

      GlobalKey<FormState> formKey = GlobalKey<FormState>();

      CartsCubit cartsCubit = CartsCubit.get(mainContext);

      CartQuantityAfterComa afterComa = cartsCubit.cartActions.convertDecimalToCartQuantityAfterComa(selectedQuantity);

      void submit(){
        if(formKey.currentState!.validate()){
          if(controller.text.isEmpty && afterComa != CartQuantityAfterComa.NO_THING){
            controller.text = "0";
          }
          cartsCubit.changeQuantityToItem(id,
              (double.parse(controller.text.toString()) + cartsCubit.cartActions.getDecimalWithCartQuantityAfterComa()[afterComa]!)
          );
          Navigator.of(context).pop();
        }
      }

      return AlertDialog(
        backgroundColor: Colors.white,
        title: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      cartsCubit.returnToInitialState();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close)),
                const Spacer(),
                Text(productName),
              ],
            )),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    getAppTextField(text: quantity.toString(),
                        onSubmitted: (value) {
                          submit();
                        },
                        onChange: (value){
                      if (!RegExp(r'^\d*$').hasMatch(value)) {
                        controller.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.text.length),
                        );
                      }
                    }, validator: (value){
                      if(value.toString().isEmpty || value == null || int.parse(value.toString()) == 0){
                        if(afterComa == CartQuantityAfterComa.NO_THING){
                          return "اختر خيارا متاحا من الخيارات 'ربع أو نص ...الخ'";
                        }
                        return null;
                      }

                      if(int.parse(value.toString()) < 0){
                        return "لا يمكن أن تكون أقل من صفر";
                      }

                      if((double.parse(value.toString()) + cartsCubit.cartActions.getDecimalWithCartQuantityAfterComa()[afterComa]!)  > quantity){
                        return 'الكمية المدخلة أكبر من المتاحة!';
                      }
                    }, controller: controller
                        , fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null),
                    const SizedBox(height: 8,),
                     const Text("و", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.appGreenColor, fontSize: 22),),
                    const SizedBox(height: 8,),
                    Scrollbar(
                      interactive: true,
                      trackVisibility: true,
                      controller: scrollInfoHorizontalController,
                      thumbVisibility: true,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            controller: scrollInfoHorizontalController,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                              builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.NO_THING ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.NO_THING && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                return getAppButton(color: color, textColor: Colors.black, text: "لا شيء", onClick: (){
                                  cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.NO_THING, id);
                                  afterComa = CartQuantityAfterComa.NO_THING;
                                });
                              },
                            ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_10 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_10 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "عشر", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_10, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_10;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_9 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_9 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "تسع", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_9, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_9;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_8 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_8 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "ثمن", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_8, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_8;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_7 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_7 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "سبع", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_7, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_7;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_6 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_6 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "سدس", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_6, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_6;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_5 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_5 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "خمس", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_5, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_5;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_4 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_4 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "ربع", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_4, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_4;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_3 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_3 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "ثلث", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_3, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_3;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_1_ON_2 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_1_ON_2 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "نص", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_1_ON_2, id);
                                    afterComa = CartQuantityAfterComa.AND_1_ON_2;
                                  });
                                },
                              ),
                              const SizedBox(width: 5,),
                              BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is ChangeCartQuantityAfterComa,
                                builder: (context, state) {
                                  Color color = afterComa == CartQuantityAfterComa.AND_3_ON_4 ? AppColors.appGreenColor : AppColors.appGrey;
                                  if(state is ChangeCartQuantityAfterComa && state.cartQuantityAfterComa == CartQuantityAfterComa.AND_3_ON_4 && state.id == id){
                                    color = AppColors.appGreenColor;
                                  }
                                  return getAppButton(color: color, textColor: Colors.black, text: "ثلاثة أرباع (إلا ربع)", onClick: (){
                                    cartsCubit.changeCartQuantityAfterComa(CartQuantityAfterComa.AND_3_ON_4, id);
                                    afterComa = CartQuantityAfterComa.AND_3_ON_4;
                                  });
                                },
                              ),                            ]
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    getAppButton(color: AppColors.appLightBlueColor, textColor: Colors.black, text: "حفظ", onClick: (){
                      submit();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),

        // actions: <Widget>[
        //
        // ],
      );
    },
  );
}
