import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/business/sections/products_cubit.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_option_button_Item_widget.dart';
import 'package:prods/features/control_panel/models/category_model.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

class AddEditProductPage extends StatelessWidget {
  const AddEditProductPage({super.key, required this.productId});

  final String? productId;
  @override
  Widget build(BuildContext mainContext) {
    final ProductsCubit cubit = BlocProvider.of<ProductsCubit>(mainContext);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController remainedQuantityController = TextEditingController();
    final TextEditingController boughtQuantityController = TextEditingController();
    final ScrollController scrollCategoryController = ScrollController();
    final formKey = GlobalKey<FormState>();
    final StringBuffer titleWord = StringBuffer("إضافة منتج جديد");
    String? id;

    if (productId != "-1") {
      cubit.getProductDetailById(productId!);
    }else{
      cubit.productsActions.clearItemFromSelectedCategoriesForProductAddingFilter();
    }
    CategoriesCubit.get(mainContext).getAllCategories();

    return Scaffold(
       body: SafeArea(
           child: Directionality(
             textDirection: TextDirection.rtl,
             child: BlocBuilder<ProductsCubit, ControlPanelState>(
               buildWhen: (previous, current) => current is GetProductDetailState,
            builder: (context, mainState) {
                 if(mainState is GetProductDetailState && ! mainState.isLoaded) {
                   return Center(
                     child: getAppProgress(),
                   );
                 }

                 if(mainState is GetProductDetailState && mainState.isLoaded) {
                   if(mainState.isSuccess){
                     id = mainState.productModel!.id;
                     cubit.setCategoriesForProductEditing(mainState.productModel!.categoryIds.map((e) => e.toString()).toList());
                     nameController.text = mainState.productModel!.name;
                     priceController.text = mainState.productModel!.price.toString();
                     remainedQuantityController.text = mainState.productModel!.remainedQuantity.toString();
                     boughtQuantityController.text = mainState.productModel!.boughtQuantity.toString();
                     titleWord.clear();
                     titleWord.write("تعديل المنتج ''${mainState.productModel!.name}''");
                   }
                 }

            return SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: SizedBox(
                   width: double.infinity,
                   child: Form(
                     key: formKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       textDirection: TextDirection.rtl,
                       children: [
                         const SizedBox(height: 10,),
                         Row(
                           children: [
                             IconButton(
                                 onPressed: (){
                                   context.pop();
                                 },icon: const Icon(CupertinoIcons.back)),
                             Text(titleWord.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                           ],
                         ),
                         SizedBox(
                           width: MediaQuery.of(context).size.width > ScreensSizes.smallScreen ? MediaQuery.of(context).size.width * (50/100)  : MediaQuery.of(context).size.width ,
                           child: Column(
                             children: [
                               const SizedBox(height: 40,),
                               getAppTextField(
                                   inputType: TextInputType.name,
                                   text: "اسم المنتج", onChange: (value){}, validator: (value){
                                     if(value.isEmpty){
                                       return "اسم المنتج مطلوب";
                                     }
                               }, controller: nameController, fillColor: Colors.black12, obscureText: false, direction: TextDirection.rtl, suffixIconButton: null),
                               const SizedBox(height: 10,),
                               SizedBox(height: 30,
                                 width: double.infinity,
                                 child: BlocBuilder<CategoriesCubit, ControlPanelState>(
                                   buildWhen: (previous, current) => current is GetAllCategoriesState,
                                   builder: (context, state) {
                                     if(state is GetAllCategoriesState){
                                       if(! state.isLoaded){
                                         return getAppProgress();
                                       }
                                       if(state.isSuccess){
                                         List<CategoryModel> data = state.categories!;
                                         if(data.isEmpty){
                                           return Container();
                                         }
                                         return Scrollbar(
                                           interactive: true,
                                           trackVisibility: true,
                                           controller: scrollCategoryController,
                                           thickness: 8.0,
                                           child: SizedBox(
                                             height: 30,
                                             child: ListView.separated(
                                               controller: scrollCategoryController,
                                               separatorBuilder: (context, index) => const SizedBox(width: 5,),
                                               scrollDirection: Axis.horizontal,
                                               itemCount: data.length,
                                               itemBuilder: (context, index){
                                                 return Container(
                                                   decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(25),
                                                   ),
                                                   child: BlocBuilder<ProductsCubit, ControlPanelState>(
                                                         buildWhen: (previous, current) => current is GetSelectedCategoriesForProductAddingState,
                                                        builder: (context, state) {
                                                           var bgColor = Colors.black54;
                                                           if(state is GetSelectedCategoriesForProductAddingState && state.catIds.contains(data[index].id)){
                                                             bgColor = AppColors.appGreenColor;
                                                           }
                                                          return FilterOptionButtonItemWidget(
                                                           text: data[index].name, color: Colors.white, bgColor: bgColor,
                                                           onClick: () => cubit.selectNewCategoryOrUnSelectForProductAdding(data[index].id)
                                                         ,);
                                                           },
                                                       )
                                                 );
                                               },),
                                           ),
                                         );
                                       }
                                     }
                                     return getAppProgress();
                                   },
                                 )




                                 ,
                               ),
                               Column(
                                 children: [
                                   const SizedBox(height: 10,),
                                   getAppTextField(
                                       inputType: TextInputType.number,
                                       text: "سعر المنتج",
                                       onChange: (value){
                                     if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                                       priceController.text = value.replaceAll(RegExp(r'[^0-9.]'), '');
                                       priceController.selection = TextSelection.fromPosition(
                                         TextPosition(offset: priceController.text.length),
                                       );
                                     }
                                   }, validator: (value){
                                         if(value.toString().isEmpty){
                                           return "السعر يجب أن يكون قيمة رقمية";
                                         }
                                         return null;
                                       },
                                   controller: priceController, fillColor: Colors.black12, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null),

                               const SizedBox(height: 10,),
                               getAppTextField(
                                   inputType: TextInputType.number,
                                   text: "الكمية المتبقية", onChange: (value){
                                 if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                                   remainedQuantityController.text = value.replaceAll(RegExp(r'[^0-9.]'), '');
                                   remainedQuantityController.selection = TextSelection.fromPosition(
                                     TextPosition(offset: remainedQuantityController.text.length),
                                   );
                                 }
                               }, validator: (value){
                                     if(value.toString().isEmpty ){
                                       return "الكمية المتبقية يجب أن يكون رقم صحيح";
                                     }
                                     return null;
                               }, controller: remainedQuantityController, fillColor: Colors.black12, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null),
                               const SizedBox(height: 10,),
                               getAppTextField(
                                   inputType: TextInputType.number,
                                   text: "الكمية التي تم بيعها", onChange: (value){
                                 if (!RegExp(r'^\d*\.?\d*$').hasMatch(value)) {
                                   boughtQuantityController.text = value.replaceAll(RegExp(r'[^0-9.]'), '');
                                   boughtQuantityController.selection = TextSelection.fromPosition(
                                     TextPosition(offset: boughtQuantityController.text.length),
                                   );
                                 }
                               }, validator: (value){
                                 if( value.toString().isEmpty ){
                                   return "الكمية التي تم بيعها يجب أن يكون رقم صحيح";
                                 }
                                 return null;
                               }, controller: boughtQuantityController, fillColor: Colors.black12, obscureText: false, direction: TextDirection.ltr, suffixIconButton: null),
                               const SizedBox(height: 10,),
                                                              ],
                                                            ),
                               BlocConsumer<ProductsCubit, ControlPanelState>(
                                 listenWhen: (previous, current) => current is AddEditProductState,
                                 buildWhen: (previous, current) => current is AddEditProductState,
                                 builder: (context, state) {
                                 if(state is AddEditProductState && ! state.isLoaded){
                                   return getAppProgress();
                                 }

                                return getAppButton(color: AppColors.appGreenColor, textColor: Colors.black, text: "حفظ",
                                    onClick: () {
                                  if(formKey.currentState!.validate()){
                                    if(id != null){
                                      cubit.editProduct(
                                          ProductModel(id: id!, name: nameController.text, price: double.parse(priceController.text), categoryIds: cubit.productsActions.getSelectedCategoriesForProductAdding(), remainedQuantity: double.parse(remainedQuantityController.text), boughtQuantity: double.parse(boughtQuantityController.text), createdAt: Timestamp.now(), updatedAt: Timestamp.now())
                                      );
                                    }
                                    else{
                                      cubit.addNewProduct(
                                          ProductModel(id: "", name: nameController.text, price: double.parse(priceController.text), categoryIds: cubit.productsActions.getSelectedCategoriesForProductAdding(), remainedQuantity: double.parse(remainedQuantityController.text), boughtQuantity: double.parse(boughtQuantityController.text), createdAt: Timestamp.now(), updatedAt: Timestamp.now())
                                      );
                                    }

                                  }
                                });
                              },
                                 listener: (context, state) {
                                   if(state is AddEditProductState && state.isLoaded){
                                     if(state.isSuccess){
                                       showCustomToast(context: context, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.black);
                                     }else{
                                       showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                                     }
                                   }
                                 },
                            )
                          ],
                           ),
                         )
                       ],
                     ),
                   ),
                 ),
               ),
             );
            },
           ),
         ),
       ),
    );
  }
}
