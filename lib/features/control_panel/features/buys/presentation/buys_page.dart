import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/sections/buys_cubit.dart';
import 'package:prods/features/control_panel/features/buys/presentation/show_add_edit_new_buy_option.dart';
import 'package:prods/features/control_panel/models/buy_model.dart';

import '../../../../../core/consts/app_colors.dart';
import '../../../../../core/consts/app_images.dart';
import '../../../business/control_panel_cubit.dart';

class BuysPage extends StatelessWidget {
  const BuysPage({super.key});

  @override
  Widget build(BuildContext pageContext) {
    BuysCubit buysCubit = BuysCubit.get(pageContext);
    final ScrollController scrollInfoHorizontalController = ScrollController();

    buysCubit.getAllBuys();    // cubit.changeSortBuyTypeSelected(SortBuyType.FROM_NEWEST_TO_OLDERS, controller.text);

    return SizedBox(
        width: double.infinity,
        child: Column(
            children: [
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
                                  "المشتريات",
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
                        BlocConsumer<BuysCubit, ControlPanelState>(
                          builder: (context, state) {
                            return getAppButton(
                                icon: Icons.add,
                                color: Colors.white,
                                textColor: Colors.black,
                                text: MediaQuery.sizeOf(pageContext).width >
                                    ScreensSizes.smallScreen
                                    ? "إضافة عملية شراء جديدة"
                                    : "",
                                onClick: () {
                                  showAddEditNewBuyOption(pageContext, null);
                                });
                          },
                          listenWhen: (previous, current) => current is AddEditBuyState && current.isLoaded && current.isForAdd,
                          listener: (context, state) {
                            if(state is AddEditBuyState){
                              if (state.isSuccess) {
                                showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.white);
                              }
                              else{
                                showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 10,),
                        getAppButton(
                            icon: Icons.date_range,
                            color: Colors.white,
                            textColor: Colors.black,
                            text: MediaQuery.sizeOf(pageContext).width >
                                ScreensSizes.smallScreen
                                ? "فلترة بالوقت"
                                : "",
                            onClick: () {

                            }),
                        const SizedBox(width: 10,),
                        getAppButton(
                            icon: Icons.print,
                            color: Colors.white,
                            textColor: Colors.black,
                            text: MediaQuery.sizeOf(pageContext).width >
                                ScreensSizes.smallScreen
                                ? "إنشاء فاتورة"
                                : "",
                            onClick: () {}
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<BuysCubit, ControlPanelState>(
                  buildWhen: (previous, current) =>
                  current is GetAllBuysState,
                  builder: (context, state) {
                    if (state is GetAllBuysState) {
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
                              buysCubit.getAllBuys();
                            });
                      }

                      List<BuyModel>? data = state.buys;
                      if (data == null || data.isEmpty) {
                        return const Text("فارغ");
                      }

                      return Scrollbar(
                        controller: scrollInfoHorizontalController,
                        interactive: true,
                        thumbVisibility: true,
                        trackVisibility: true,
                        child: SingleChildScrollView(
                            controller: scrollInfoHorizontalController,
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
                                  getAppDataColumn('الاسم'),
                                  getAppDataColumn('الوحدة'),
                                  getAppDataColumn('الكمية'),
                                  getAppDataColumn('سعر الشراء'),
                                  getAppDataColumn('سعر البيع'),
                                  getAppDataColumn('إجمالي الشراء'),
                                  getAppDataColumn('إجمالي البيع'),
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
                                            BlocConsumer<BuysCubit, ControlPanelState>(
                                              builder: (context, state) {
                                                return MaterialButton(
                                              elevation: 0,
                                              color: AppColors.appGreenColor,
                                              onPressed: () {
                                                showAddEditNewBuyOption(pageContext, data[index]);
                                              },
                                              child: Image.asset(AppImages.edit),);
                                          },
                                              listenWhen: (previous, current) => current is AddEditBuyState && current.isSuccess && current.buyModel!.id == data[index].id,
                                              listener: (context, state) {
                                                if(state is AddEditBuyState){
                                                  if (state.isSuccess) {
                                                    showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.white);
                                                  }
                                                  else{
                                                    showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                                                  }
                                                }
                                              },
                                        ),
                                        const SizedBox(width: 10,),
                                            BlocConsumer<BuysCubit,
                                                ControlPanelState>(
                                              buildWhen: (previous, current) =>
                                              current
                                              is DeleteBuyState &&
                                                  current.buyModel.id ==
                                                      data[index].id,
                                              listenWhen: (previous, current) =>
                                              current is DeleteBuyState &&
                                                  current.buyModel.id ==
                                                      data[index].id,
                                              listener: (context, state) {
                                                if (state is DeleteBuyState && state.isLoaded) {
                                                  if (state.isSuccess) {
                                                    showCustomToast(
                                                        context: context,
                                                        message: state.message,
                                                        bkgColor: AppColors
                                                            .appGreenColor,
                                                        textColor:
                                                        Colors.black);
                                                  } else {
                                                    showCustomToast(
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
                                                if (state is DeleteBuyState &&
                                                    !state.isLoaded) {
                                                  return getAppProgress();
                                                }
                                                return MaterialButton(
                                                  elevation: 0,
                                                  color: AppColors.appRedColor,
                                                  onPressed: () {

                                                      showDeleteConfirmationMessage(
                                                          context,
                                                          Colors.white,
                                                          "حذف '${data[index].name}'",
                                                          "هل أنت متأكد، لن تتمكن من استرجاعه بمجرد الحذف",
                                                              () {
                                                            buysCubit.deleteBuy(
                                                                index, data[index]);
                                                          });
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
                                      getAppDataCell((data[index].unit)),
                                      getAppDataCell(
                                          "${data[index].quantity}"),
                                      getAppDataCell(formatNumber(data[index].priceOfBuy)),
                                      getAppDataCell(formatNumber(data[index].priceOfSell)),
                                      getAppDataCell(formatNumber(data[index].priceOfBuy * data[index].quantity)),
                                      getAppDataCell(formatNumber(data[index].priceOfSell * data[index].quantity)),
                                      getAppDataCell(getFormatedDate(
                                          data[index].createdAt.toDate())
                                      ),
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
