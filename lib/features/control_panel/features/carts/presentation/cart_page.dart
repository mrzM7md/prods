import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/app_images.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/business/sections/invoice_cubit.dart';
import 'package:prods/features/control_panel/features/carts/presentation/show/show_complete_invoice_preparing.dart';
import 'package:prods/features/control_panel/features/categories/presentation/widgets/add_edit_category_widget.dart';
import 'package:prods/features/control_panel/models/product_model.dart';
import '../../../../../core/consts/helpers_methods.dart';
import '../../../../../core/consts/widgets_components.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext pageContext) {
    CartsCubit cartsCubit = CartsCubit.get(pageContext);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    GlobalKey<FormState> addDiscountFormKey = GlobalKey<FormState>();
    TextEditingController controller = TextEditingController();
    TextEditingController discountController = TextEditingController();
    final ScrollController scrollInfoHorizontalController = ScrollController();
    cartsCubit.getProductsByIds(
      cartsCubit.cartActions.getCart().map((c) => c.productId).toList(),
    );

  return BlocBuilder<CartsCubit, ControlPanelState>(
    buildWhen: (previous, current) => current is GetProductsByIdsState,
    builder: (context, state) {
       if(state is GetProductsByIdsState && ! state.isLoaded){
        return getAppProgress();
      }
      if(state is GetProductsByIdsState && state.isSuccess){
        List<ProductModel>? data = state.products;
        if(data == null || data.isEmpty){
          return const Center(child: Text("فارغ"));
        }
        return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConditionalBuilder(condition: MediaQuery.sizeOf(pageContext).width <= ScreensSizes.smallScreen,
                      builder: (context) => const Column(
                        children: [
                          Text("السلة", style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                        ],
                      ), fallback: (context) => Container(),),
                  ),
                  AddEditCategoryWidget(context: pageContext, controller: controller, formKey: formKey, message: "", bkgColor: Colors.white, textColor: Colors.black),
                  BlocBuilder<CategoriesCubit, ControlPanelState>(
                    buildWhen: (previous, current) => current is ChangeAddNewOrEditCategoryBoxState, builder: (context, state) {
                    if(!(state is ! ChangeAddNewOrEditCategoryBoxState || ! state.isClickedOnAddNewCategory)) {
                      return Container();
                    }
                    return Padding(padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: BlocConsumer<InvoiceCubit, ControlPanelState>(
                            buildWhen: (previous, current) => current is AddInvoiceState,
                              listenWhen: (previous, current) => current is AddInvoiceState,
                              builder: (context, state) {
                              if(state is AddInvoiceState && ! state.isLoaded) {
                                return getAppProgress();
                              }
                              return BlocBuilder<CartsCubit, ControlPanelState>(
                                buildWhen: (previous, current) => current is DeleteItemFromCartState,
                                builder: (context, state) {
                                  if(! cartsCubit.cartActions.isThereAnyItemInsideCart()){
                                    return Container();
                                  }
                                  return getAppButton(
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    text:"إنشاء فاتورة",
                                    onClick: () async {
                                      showCompleteInvoicePreparing(pageContext, cartsCubit.cartActions.getTotalPrice());
                                    });
                              },
                            );
                                }, listener: (BuildContext context, ControlPanelState state) {
                                    if(state is AddInvoiceState && state.isLoaded) {
                                      if(state.isSuccess) {
                                        showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.black);
                                      }
                                      else{
                                        showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                                      }
                                    }
                                  },
                            ),
                          ),
                          const SizedBox(width: 5,),
                          getAppButton(color: AppColors.appGrey, textColor: Colors.red, text: MediaQuery.of(context).size.width > ScreensSizes.smallScreen ?  "حذف محتوى السلة" : "", onClick:(){
                            cartsCubit.cartActions.removeCart();
                            cartsCubit.getProductsByIds(
                              cartsCubit.cartActions.getCart().map((c) => c.productId).toList(),
                            );
                          }, icon: Icons.clear_all,  )
                        ],
                      ),
                    );
                    },),
                  const SizedBox(height: 22,),
                  Expanded(
                     child: Scrollbar(
                            interactive: true,
                            trackVisibility: true,
                            controller: scrollInfoHorizontalController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                                controller: scrollInfoHorizontalController,
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    // headingRowColor: WidgetStatePropertyAll(Colors.red),
                                    dividerThickness: 0,
                                    columnSpacing: 100,
                                    dataRowColor: WidgetStateProperty.all(
                                        Colors.white),
                                    columns: <DataColumn>[
                                      getAppDataColumn('خيارات'),
                                      getAppDataColumn('الكمية'),
                                      getAppDataColumn('اسم المنتج'),
                                      getAppDataColumn('السعر بقل الخصم'),
                                      getAppDataColumn('مقدار الخصم على القطعة'),
                                      getAppDataColumn('السعر بعد الخصم'),
                                      getAppDataColumn('السغر النهائي'),
                                    ],
                                    rows: List<DataRow>.generate(data.length,
                                          (index) {
                                      if(! cartsCubit.cartActions.isThisProductInCart(data[index].id)) {
                                    return const DataRow(cells: []);
                                  }
                                  return DataRow(
                                        color: index % 2 == 1 ? const WidgetStatePropertyAll(AppColors.appGrey) : const WidgetStatePropertyAll(Colors.white) ,
                                        // color: WidgetStatePropertyAll(Colors.red),
                                        cells: <DataCell>[
                                          DataCell(
                                              Row(
                                              children: [
                                                BlocBuilder<CartsCubit, ControlPanelState>(
                                                  buildWhen: (previous, current) => current is DeleteItemFromCartState,
                                                  builder: (context, state) {
                                                   if(state is DeleteItemFromCartState && ! state.isLoaded && state.productId == data[index].id) {
                                                     return getAppProgress();
                                                   }
                                                    return MaterialButton(
                                                  elevation: 0,
                                                  color: AppColors.appRedColor,
                                                  onPressed: () {
                                                    showDeleteConfirmationMessage(pageContext, Colors.white, "استبعاد المنتج ''${data[index].name}'' من السلة ", "هل أنت متأكد؟", (){
                                                      cartsCubit.deleteItemFromCart(data[index].id);
                                                    });
                                                  },
                                                  child: Image.asset(
                                                      AppImages.delete),
                                                );
                                              },
                                            ),
                                                const SizedBox(width: 10,),
                                                MaterialButton(elevation: 0,
                                                  color: AppColors.appGreenColor,
                                                  onPressed: () {
                                                    if(cartsCubit.cartActions.getDiscount(data[index].id) > 0.0){
                                                      discountController.text =  cartsCubit.cartActions.getDiscount(data[index].id).toString();
                                                    }
                                                    else{
                                                      discountController.text = "";
                                                    }
                                                    late OverlayEntry showOverlayEntry;
                                                    showOverlayEntry = showAddOnFieldMessage((value){
                                                      discountController.text = value.replaceAll(RegExp(r'[^0-9.]'), '');
                                                      discountController.selection = TextSelection.fromPosition(
                                                        TextPosition(offset: discountController.text.length),
                                                      );
                                                    },
                                                            (value){
                                                          if (value.toString().isEmpty || value == null) {
                                                            return "هذا الحقل مطلوب";
                                                          }
                                                          if(!cartsCubit.cartActions.isPriceBiggerThanDiscountPrice(data[index].price,
                                                              double.parse(value.toString()))){
                                                            return "يجب أن يكون الخصم أقل من السعر";
                                                          }
                                                          return null;
                                                        },addDiscountFormKey,pageContext, Colors.white, "إضافة خصم إلى'' ${data[index].name}''", "السعر الأصلي ${data[index].price}",
                                                            (){
                                                          if(addDiscountFormKey.currentState!.validate()){
                                                            cartsCubit.addDiscountToItem(data[index].id, double.parse(discountController.text));
                                                            showOverlayEntry.remove();
                                                          }
                                                        }, discountController);
                                                  },
                                                  child: BlocBuilder<CartsCubit, ControlPanelState>(
                                                    buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState && current.productId == data[index].id,
                                                    builder: (context, state) {
                                                      if(cartsCubit.cartActions.getDiscount(data[index].id) > 0.0){
                                                        return const Text("تعديل الخصم");
                                                      }
                                                      return const Text("إضافة خصم");
                                                    },
                                                  ),),
                                              ],
                                            ),

),
                                          DataCell( Row(
                                                children: [
                                                  IconButton(onPressed: (){
                                                    cartsCubit.plusOneQuantityToItem(data[index].id);
                                                  }, icon: const Icon(CupertinoIcons.plus)),
                                                  const SizedBox(width: 20,),
                                                  BlocBuilder<CartsCubit, ControlPanelState>(
                                                    buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState,
                                                    builder: (context, state) {
                                                      return Text("${cartsCubit.cartActions.getQuantity(data[index].id)} / ${data[index].remainedQuantity}");
                                                    },
                                                  ),
                                                  const SizedBox(width: 20,),
                                                  IconButton(onPressed: (){
                                                    cartsCubit.minusOneQuantityToItem(data[index].id);
                                                  }, icon: const Icon(CupertinoIcons.minus)),
                                                ],
                                              ),
                                            ),
                                          DataCell( Text(
                                                data[index].name,
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                          ),
                                          DataCell(
                                              Text(
                                                formatNumber(data[index].price),
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          DataCell(
                                            BlocBuilder<CartsCubit, ControlPanelState>(
                                            buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState && current.productId == data[index].id,
                                            builder: (context, state) {
                                              return Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    formatNumber(cartsCubit.cartActions.getDiscount(data[index].id)),
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ));
                                            },
                                          )
                                            ),
                                          DataCell(BlocBuilder<CartsCubit, ControlPanelState>(
                                                buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState && current.productId == data[index].id,
                                                builder: (context, state) {
                                                  return Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        formatNumber(cartsCubit.cartActions.getPriceAfterDiscount(data[index].id)),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ));
                                                },
                                              ),
                                          ),
                                          DataCell(BlocBuilder<CartsCubit, ControlPanelState>(
                                              buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState && current.productId == data[index].id,
                                            builder: (context, state) {
                                            return Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                            formatNumber(cartsCubit.cartActions.getPriceAfterDiscountAndQuantity(data[index].id)),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ));
                                            },
                                          )
                                    ),
                                  ],
                                );
                                    }
                                    ),
                                  ),)),
                          )
                    ),

                    Padding(padding: const EdgeInsetsDirectional.all(10),
                    child: Row(
                      children: [
                        const Text("المجموع", style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(width: 10,),
                        BlocBuilder<CartsCubit, ControlPanelState>(
                          buildWhen: (previous, current) => current is PlusMinusOneQuantityToItemAndAddDiscountState,
                          builder: (context, state) {
                            return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  formatNumber(cartsCubit.cartActions.getTotalPrice()),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ));
                          },
                        ),
                      ],
                    ),
                  )

                ]));
      }
      if(state is GetProductsByIdsState && ! state.isSuccess){
        return getAppButton(color: Colors.white,
            textColor: Colors.redAccent,
            icon: Icons.refresh,
            text: state.message, onClick: () {
              // cubit.getAllCategories();
            });
      }
      return getAppProgress();
  },
);
  }

  void getAddCategoryWidget({
    required BuildContext context,
    required String message,
    required Color bkgColor,
    required Color textColor,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) {
    OverlayEntry? overlayEntry;
    CategoriesCubit cubit = CategoriesCubit.get(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
                  overlayEntry?.remove();
                },
                icon: const Icon(Icons.close),
              ),
              const SizedBox(height: 10,),
              const Text("إضافة صنف جديد", style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold,),),
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
                  controller: controller,
                  fillColor: AppColors.appGrey,
                  obscureText: false,
                  suffixIconButton: null,
                  direction: null,
                ),
              ),
              const SizedBox(height: 20,),
              BlocConsumer<CategoriesCubit, ControlPanelState>(
                listenWhen: (previous, current) => current is AddEditCategoryState && current.isLoaded && !current.isSuccess,
                buildWhen: (previous, current) => current is AddEditCategoryState,
                builder: (context, state) {
                  if (state is AddEditCategoryState && !state.isLoaded) {
                    return getAppProgress();
                  }
                  return getAppButton(
                      color: AppColors.appGreenColor,
                      textColor: Colors.black,
                      text: "إضافة",
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          cubit.addNewCategory(controller.text);
                        }
                      });
                }, listener: (BuildContext context, ControlPanelState state) {
                if(state is AddEditCategoryState) {
                  showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black,);
                }
              },
              )
            ],
          ),
        ),
      ),
            ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

}
