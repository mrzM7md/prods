import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_routes.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_option_button_Item_widget.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_options_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/consts/app_colors.dart';
import '../../../../../core/consts/app_images.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../business/control_panel_cubit.dart';
import '../../../business/sections/products_cubit.dart';
import '../../../models/product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  late ProductsCubit _productCubit;
  late CartsCubit _cartCubit;
  late TextEditingController _controller;
  late final ScrollController _scrollCategoryController;
  late final ScrollController _scrollInfoHorizontalController;


  @override
  void initState() {
    _productCubit = ProductsCubit.get(context);
    _cartCubit = CartsCubit.get(context);
    _controller = TextEditingController();
    _scrollCategoryController = ScrollController();
    _scrollInfoHorizontalController = ScrollController();

    _productCubit.getAllProductsByFilter(_controller.text);
    super.initState();
  }

  @override
  Widget build(BuildContext pageContext) {
    // cubit.changeSortProductTypeSelected(SortProductType.FROM_NEWEST_TO_OLDERS, controller.text);
    return SizedBox(
        width: double.infinity,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AddEditProductWidget(context: pageContext, controller: controller, formKey: formKey, message: "", bkgColor: Colors.white, textColor: Colors.black),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConditionalBuilder(condition: MediaQuery.sizeOf(pageContext).width <= ScreensSizes.smallScreen,
                      builder: (context) => const Column(
                        children: [
                          Padding(padding: EdgeInsetsDirectional.all(5),
                            child: Column(
                              children: [
                                Text(
                                  "المبيعات",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), fallback: (context) => Container(),),
                    Row(
                      children: [
                        getAppButton(
                            icon: Icons.add,
                            color: Colors.white,
                            textColor: Colors.black,
                            text: MediaQuery.sizeOf(pageContext).width >
                                    ScreensSizes.smallScreen
                                ? "إضافة منتج جديد"
                                : "",
                            onClick: () {
                              pageContext.goNamed(
                                AppRoutes.addEditProductRouter,
                                pathParameters: {"id": "-1"},
                              );
                            }),
                        const SizedBox(
                          width: 15,
                        ),
                        getAppButton(
                            color: Colors.white,
                            textColor: Colors.black,
                            text: MediaQuery.sizeOf(pageContext).width >
                                    ScreensSizes.smallScreen
                                ? "خيارات التصفية"
                                : "",
                            icon: Icons.filter_alt_rounded,
                            onClick: () {
                              _productCubit.changeFilterOptions();
                            }),
                        SizedBox(
                          width: 200,
                          child: getAppTextField(
                              text: "ابحث عن منتج",
                              onChange: (value) {},
                              validator: (value) {},
                              controller: _controller,
                              fillColor: AppColors.appGrey,
                              obscureText: false,
                              direction: TextDirection.rtl,
                              suffixIconButton: const Icon(Icons.search_outlined),
                              onSubmitted: (value) {
                                _productCubit.changeSortProductTypeSelected(
                                    _productCubit.productsActions.getProductTypeFilter(),
                                    value);
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<ProductsCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is ChangeFilterOptionsState,
                builder: (context, state) {
                  if(! _productCubit.productsActions.getFilterOptionsVisibility()){
                    return Container();
                  }
                  return Column(
                    children: [
                      const SizedBox(
                        height: 22,
                      ),
                    SizedBox(
                      height: 30,
                      child: FilterCategoriesOptionsWidget(
                        scrollCategoryController: _scrollCategoryController,
                        searchText: _controller.text,
                    ),
                  ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              BlocBuilder<ProductsCubit, ControlPanelState>(
                                buildWhen: (previous, current) =>
                                current is GetSortProductTypeSelectedState,
                                builder: (context, state) {
                                  var bgColor = Colors.black54;
                                  if (state is GetSortProductTypeSelectedState ==
                                      false) {
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  if (state is GetSortProductTypeSelectedState &&
                                      state.type ==
                                          SortProductType.FROM_NEWEST_TO_OLDERS) {
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  return FilterOptionButtonItemWidget(
                                      bgColor: bgColor,
                                      color: Colors.white,
                                      text: "من الأحدث للأقدم",
                                      onClick: () =>
                                          _productCubit.changeSortProductTypeSelected(
                                              SortProductType.FROM_NEWEST_TO_OLDERS,
                                              _controller.text));
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              BlocBuilder<ProductsCubit, ControlPanelState>(
                                buildWhen: (previous, current) =>
                                current is GetSortProductTypeSelectedState,
                                builder: (context, state) {
                                  var bgColor = Colors.black54;
                                  if (state is GetSortProductTypeSelectedState &&
                                      state.type ==
                                          SortProductType.FROM_OLDEST_TO_NEWEST) {
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  return FilterOptionButtonItemWidget(
                                      bgColor: bgColor,
                                      color: Colors.white,
                                      text: "من الأقدم للأحدث",
                                      onClick: () =>
                                          _productCubit.changeSortProductTypeSelected(
                                              SortProductType.FROM_OLDEST_TO_NEWEST,
                                              _controller.text));
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              BlocBuilder<ProductsCubit, ControlPanelState>(
                                buildWhen: (previous, current) =>
                                current is GetSortProductTypeSelectedState,
                                builder: (context, state) {
                                  var bgColor = Colors.black54;
                                  if (state is GetSortProductTypeSelectedState &&
                                      state.type ==
                                          SortProductType.FROM_MUST_SELLING_TO_LEAST) {
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  return FilterOptionButtonItemWidget(
                                      bgColor: bgColor,
                                      color: Colors.white,
                                      text: "من الأكثر مبيعا للأقل مبيعا",
                                      onClick: () =>
                                          _productCubit.changeSortProductTypeSelected(
                                              SortProductType
                                                  .FROM_MUST_SELLING_TO_LEAST,
                                              _controller.text));
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              BlocBuilder<ProductsCubit, ControlPanelState>(
                                buildWhen: (previous, current) =>
                                current is GetSortProductTypeSelectedState,
                                builder: (context, state) {
                                  var bgColor = Colors.black54;
                                  if (state is GetSortProductTypeSelectedState &&
                                      state.type ==
                                          SortProductType.FROM_LEAS_SELLING_TO_MUST) {
                                    bgColor = AppColors.appGreenColor;
                                  }
                                  return FilterOptionButtonItemWidget(
                                      bgColor: bgColor,
                                      color: Colors.white,
                                      text: "من الأقل مبيعا للأكثر مبيعا",
                                      onClick: () =>
                                          _productCubit.changeSortProductTypeSelected(
                                              SortProductType.FROM_LEAS_SELLING_TO_MUST,
                                              _controller.text));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              );
  },
),
              Expanded(
                child: BlocBuilder<ProductsCubit, ControlPanelState>(
                  buildWhen: (previous, current) =>
                      current is GetAllProductsState,
                  builder: (context, state) {
                    if (state is GetAllProductsState) {
                      if (!state.isLoaded) {
                        return getAppProgress();
                      }
                      if (!state.isSuccess) {
                        return getAppButton(
                            color: Colors.white,
                            textColor: Colors.redAccent,
                            icon: Icons.refresh,
                            text: state.message,
                            onClick: () {
                              _productCubit.getAllProductsByFilter(_controller.text);
                            });
                      }

                      List<ProductModel>? data = state.products;
                      if (data == null || data.isEmpty) {
                        return const Text("فارغ");
                      }

                      return Scrollbar(
                        controller: _scrollInfoHorizontalController,
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                            controller: _scrollInfoHorizontalController,
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                // headingRowColor: WidgetStatePropertyAll(Colors.red),
                                dividerThickness: 0,
                                columnSpacing: 100,
                                dataRowColor:
                                    WidgetStateProperty.all(Colors.white),
                                columns: <DataColumn>[
                                  getAppDataColumn('خيارات'),
                                  getAppDataColumn('اسم المنتج'),
                                  getAppDataColumn('سعر المنتج'),
                                  getAppDataColumn('تصنيفه'),
                                  getAppDataColumn('الكمية المتبقية'),
                                  getAppDataColumn('الكمية التي تم بيعها'),
                                  getAppDataColumn('تاريخ الإنشاء'),
                                  getAppDataColumn('تاريخ التعديل'),
                                ],
                                rows: List<DataRow>.generate(
                                  data.length,
                                  (index) => DataRow(
                                    color: index % 2 == 1
                                        ? const WidgetStatePropertyAll(
                                            AppColors.appGrey)
                                        : const WidgetStatePropertyAll(
                                            Colors.white),
                                    // color: WidgetStatePropertyAll(Colors.red),
                                    cells: <DataCell>[
                                      DataCell(
                                        Row(
                                          children: [
                                            BlocConsumer<CartsCubit, ControlPanelState>(
                                              buildWhen: (previous, current) => current is AddToCartState && current.productId == data[index].id,
                                          listenWhen: (previous, current) => current is AddToCartState && current.productId == data[index].id,
                                              listener: (context, state) {
                                                if (state is AddToCartState) {
                                                  if(state.isSuccess) {
                                                    sl<ShowCustomMessage>().showCustomToast(context: context, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.black54);
                                                  }else{
                                                    sl<ShowCustomMessage>().showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black54);
                                                  }
                                                }
                                          },
                                          builder: (context, state) {
                                            if(_cartCubit.cartActions.idThereProductInCart(data[index].id)) {
                                              return Container(width: 85,);
                                            }
                                                return MaterialButton(
                                              elevation: 0,
                                              // color: Colors.white,
                                              onPressed: () {
                                                if(data[index].remainedQuantity < 1.0){
                                                  sl<ShowCustomMessage>().showCustomToast(context: pageContext, message: "نفدت كمية هذا المنتج", bkgColor: AppColors.appRedColor, textColor: Colors.black);
                                                } else{
                                                  _cartCubit.addToCart(data[index]);
                                                }
                                              },
                                              child: Image.asset(
                                                data[index].remainedQuantity < 1 ? AppImages.rejectedCart : AppImages.addToCart,
                                                height: 25,
                                              ),
                                            );
                                          },
                                        ),
                                            const SizedBox(
                                              width: 60,
                                            ),
                                            MaterialButton(
                                              elevation: 0,
                                              color: AppColors.appGreenColor,
                                              onPressed: () {
                                                if(_cartCubit.cartActions.idThereProductInCart(data[index].id)) {
                                                  sl<ShowCustomMessage>().showCustomToast(context: context, message: "لا يمكنك تعديل منتج مضاف للسلة", bkgColor: AppColors.appRedColor, textColor: Colors.black54);
                                                }
                                                else{
                                                  pageContext.goNamed(
                                                    AppRoutes
                                                        .addEditProductRouter,
                                                    pathParameters: {"id": data[index].id},
                                                  );
                                                }

                                              },
                                              child: Image.asset(AppImages.edit),),
                                            const SizedBox(width: 10,),
                                            BlocConsumer<ProductsCubit,
                                                ControlPanelState>(
                                              buildWhen: (previous, current) =>
                                                  current
                                                      is DeleteProductState &&
                                                  current.productModel.id ==
                                                      data[index].id,
                                              listenWhen: (previous, current) =>
                                                  current is DeleteProductState &&
                                                  current.productModel.id ==
                                                      data[index].id,
                                              listener: (context, state) {
                                                if (state is DeleteProductState && state.isLoaded) {
                                                  if (state.isSuccess) {
                                                    sl<ShowCustomMessage>().showCustomToast(
                                                        context: context,
                                                        message: state.message,
                                                        bkgColor: AppColors
                                                            .appGreenColor,
                                                        textColor:
                                                            Colors.black);
                                                  } else {
                                                    sl<ShowCustomMessage>().showCustomToast(
                                                        context: context,
                                                        message: state.message,
                                                        bkgColor: AppColors
                                                            .appRedColor,
                                                        textColor:
                                                            Colors.black);
                                                  }
                                                }
                                              },
                                              builder: (context, state) {
                                                if (state is DeleteProductState &&
                                                    !state.isLoaded) {
                                                  return getAppProgress();
                                                }
                                                return MaterialButton(
                                                  elevation: 0,
                                                  color: AppColors.appRedColor,
                                                  onPressed: () {
                                                    if(_cartCubit.cartActions.idThereProductInCart(data[index].id)) {
                                                      sl<ShowCustomMessage>().showCustomToast(context: context, message: "لا يمكنك حذف منتج مضاف للسلة", bkgColor: AppColors.appRedColor, textColor: Colors.black54);
                                                    }
                                                    else{
                                                      showDeleteConfirmationMessage(
                                                          context,
                                                          Colors.white,
                                                          "حذف '${data[index].name}'",
                                                          "هل أنت متأكد، لن تتمكن من استرجاعه بمجرد الحذف",
                                                              () {
                                                            _productCubit.deleteProduct(
                                                                index, data[index]);
                                                              });
                                                        }

                                                      },
                                                      child: Image.asset(
                                                          AppImages.delete),
                                                    );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      getAppDataCell(data[index].name),
                                      getAppDataCell(formatNumber(data[index].price)),
                                      DataCell(
                                        Align(
                                            alignment: Alignment.center,
                                            child: Text("${data[index].categoriesNames == null || data[index].categoriesNames!.isEmpty ? "" : data[index].categoriesNames }",
                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                            )
                                        ),
                                      ),
                                      getAppDataCell(
                                          "${data[index].remainedQuantity}"),
                                      getAppDataCell(
                                          "${data[index].boughtQuantity}"),
                                      getAppDataCell(getFormatedDate(
                                          data[index].createdAt.toDate())),
                                      getAppDataCell(
                                        getFormatedDate(
                                            data[index].updatedAt.toDate()),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                      );
                    }
                    return getAppProgress();
                  },
                ),
              )
            ]));
  }
}
