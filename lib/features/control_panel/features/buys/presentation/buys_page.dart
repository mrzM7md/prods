import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/business/app_cubit.dart';
import 'package:prods/core/business/app_state.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/show_components.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/sections/buys_cubit.dart';
import 'package:prods/features/control_panel/features/buys/presentation/show_add_edit_new_buy_option.dart';
import 'package:prods/features/control_panel/models/buy_model.dart';

import '../../../../../core/consts/app_colors.dart';
import '../../../../../core/consts/app_images.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../business/control_panel_cubit.dart';

import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BuysPage extends StatefulWidget {
  const BuysPage({super.key});

  @override
  State<BuysPage> createState() => _BuysPageState();
}

class _BuysPageState extends State<BuysPage> {

  late BuysCubit _buysCubit;
  late AppCubit _appCubit;
  late final GlobalKey _globalKey;
  late final ScrollController _scrollInfoHorizontalController;

  @override
    void initState() {
      super.initState();
      _buysCubit = BuysCubit.get(context);
      _appCubit = AppCubit.get(context);
      _buysCubit.getAllBuys();   // cubit.changeSortBuyTypeSelected(SortBuyType.FROM_NEWEST_TO_OLDERS, controller.text);
      _globalKey = GlobalKey();
      _scrollInfoHorizontalController = ScrollController();

      _appCubit.goToAppStateInitialState();
      _appCubit.appActions.setTemporaryTimeFrom(Timestamp.fromDate(
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        )
      ));
      _appCubit.appActions.setTemporaryTimeTo(Timestamp.fromDate(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          )
      ));
  }


  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    final image = await _capturePng();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pw.MemoryImage(image)),
          ); // Center
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/buys_invoice.pdf");
    await file.writeAsBytes(await pdf.save());

    // فتح ملف الـ PDF بعد إنشائه
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext pageContext) {
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
                                sl<ShowCustomMessage>().showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.white);
                              }
                              else{
                                sl<ShowCustomMessage>().showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                              }
                            }
                          },
                        ),
                        const SizedBox(width: 10,),
                        BlocBuilder<AppCubit, AppState>(
                          buildWhen: (previous, current) => current is ClickOnSaveFilterOptionState,
                          builder: (context, state) {
                            Color color = Colors.white;
                            if(state is ClickOnSaveFilterOptionState){
                              color = AppColors.appLightBlueColor;
                            }
                            return getAppButton(
                            icon: Icons.date_range,
                            color: color,
                            textColor: Colors.black,
                            text: MediaQuery.sizeOf(pageContext).width >
                                ScreensSizes.smallScreen
                                ? "تصفية بالتاريخ"
                                : "",
                            onClick: () {
                              sl<AppDialogs>().showFilterByTime(pageContext, _appCubit.appActions.getTemporaryTimeFrom(), _appCubit.appActions.getTemporaryTimeFrom(), (){
                                _buysCubit.getAllBuys(from: _appCubit.appActions.getTemporaryTimeFrom(), to: _appCubit.appActions.getTemporaryTimeTo());
                                _appCubit.clickOnSaveFilterOption();
                              });
                            });
                          },
                        ),
                        const SizedBox(width: 10,),
                        BlocBuilder<BuysCubit, ControlPanelState>(
                          buildWhen: (previous, current) => current is GetAllBuysState,
                          builder: (context, state) {
                            return ConditionalBuilder(
                                condition: state is GetAllBuysState && state.buys != null && state.buys!.isNotEmpty,
                                builder: (context) =>
                                    getAppButton(
                                    icon: Icons.print,
                                    color: Colors.white,
                                    textColor: Colors.black,
                                    text: MediaQuery.sizeOf(pageContext).width >
                                        ScreensSizes.smallScreen
                                        ? "إنشاء فاتورة"
                                        : "",
                                    onClick: () {
                                      _generatePdf();
                                    }
                                ),
                                fallback: (context) => Container(),
                            );
  },
),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<BuysCubit, ControlPanelState>(
                  buildWhen: (previous, current) => current is GetAllBuysState,
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
                              _buysCubit.getAllBuys();
                            });
                      }

                      List<BuyModel>? data = state.buys;
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
                              child: RepaintBoundary(
                                key: _globalKey,
                                child: Column(
                                  children: [
                                    Align(
                                      child: Container(
                                        margin: const EdgeInsetsDirectional.only(top: 10),
                                        width: MediaQuery.of(pageContext).size.width,
                                        padding: const EdgeInsetsDirectional.all(10),
                                        color: AppColors.appLightGreenColor,
                                        child: BlocBuilder<AppCubit, AppState>(
                                        buildWhen: (previous, current) => current is ClickOnSaveFilterOptionState,
                                        builder: (context, state) {
                                          if(state is ClickOnSaveFilterOptionState){
                                            return Column(
                                              children: [
                                                Text("عرض عمليات الشراء التي قمت بها ${_appCubit.appActions.getTimeFilterStatement()}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold),),
                                                const SizedBox(height: 20,),
                                                Text("محموع المشتريات ${formatNumber(_buysCubit.buysActions.getTotalPriceOfBuys())}  ،  محموع المبيعات ${formatNumber(_buysCubit.buysActions.getTotalPriceOfSells())}", style: const TextStyle(fontWeight: FontWeight.bold),)
                                            ]);
                                          }
                                          return Column(
                                            children: [
                                              const Text("عرض جميع عمليات الشراء التي قمت بها", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 20,),
                                              Text("محموع المشتريات ${formatNumber(_buysCubit.buysActions.getTotalPriceOfBuys())}  ،  محموع المبيعات ${formatNumber(_buysCubit.buysActions.getTotalPriceOfSells())}", style: const TextStyle(fontWeight: FontWeight.bold),)
                                            ],
                                          );
                                        },
                                      ),
                                      ),
                                    ),
                                    DataTable(
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
                                                          sl<ShowCustomMessage>().showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.white);
                                                        }
                                                        else{
                                                          sl<ShowCustomMessage>().showCustomToast(context: pageContext, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
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
                                                                  _buysCubit.deleteBuy(
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
                                  ],
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
