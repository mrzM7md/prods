import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/sections/invoice_cubit.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_option_button_Item_widget.dart';
import 'package:prods/features/control_panel/models/invoice_model.dart';
import '../../../../../core/consts/app_colors.dart';
import '../../../../../core/services/services_locator.dart';
import '../../../business/control_panel_cubit.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {

  late final ScrollController scrollInfoHorizontalController;
  late final InvoiceCubit invoiceCubit;


  @override
  void initState() {
    scrollInfoHorizontalController = ScrollController();
    invoiceCubit = InvoiceCubit.get(context)..getInvoiceToday();
    super.initState();
  }

  @override
  Widget build(BuildContext pageContext) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const FilterInvoicesByDateToData(),
              // AddEditProductWidget(context: pageContext, controller: controller, formKey: formKey, message: "", bkgColor: Colors.white, textColor: Colors.black),
              const SizedBox(
                height: 25,
              ),
              ConditionalBuilder(condition: MediaQuery.sizeOf(pageContext).width <= ScreensSizes.smallScreen,
                builder: (context) => const Column(
                  children: [
                    Text("الفواتير", style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                  ],
                ), fallback: (context) => Container(),),
              SizedBox(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      BlocBuilder<InvoiceCubit, ControlPanelState>(
                        buildWhen: (previous, current) =>
                            current is ChangeInvoiceTypeSelectedState,
                        builder: (context, state) {
                          var bgColor = Colors.black54;
                          if (state is! ChangeInvoiceTypeSelectedState) {
                            bgColor = AppColors.appGreenColor;
                          }
                          if (state is ChangeInvoiceTypeSelectedState &&
                              state.type == InvoiceFilterType.TODAY) {
                            bgColor = AppColors.appGreenColor;
                          }
                          return FilterOptionButtonItemWidget(
                              bgColor: bgColor,
                              color: Colors.white,
                              text: "لهذا اليوم",
                              onClick: () {
                                invoiceCubit.getInvoiceToday();
                              });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      BlocBuilder<InvoiceCubit, ControlPanelState>(
                        buildWhen: (previous, current) =>
                            current is ChangeInvoiceTypeSelectedState,
                        builder: (context, state) {
                          var bgColor = Colors.black54;
                          if (state is ChangeInvoiceTypeSelectedState &&
                              state.type == InvoiceFilterType.LAST_2_DAYS) {
                            bgColor = AppColors.appGreenColor;
                          }
                          return FilterOptionButtonItemWidget(
                              bgColor: bgColor,
                              color: Colors.white,
                              text: "آخر يومين",
                              onClick: () {
                                invoiceCubit.getInvoiceLast2Days();
                              });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      BlocBuilder<InvoiceCubit, ControlPanelState>(
                        buildWhen: (previous, current) =>
                            current is ChangeInvoiceTypeSelectedState,
                        builder: (context, state) {
                          var bgColor = Colors.black54;
                          if (state is ChangeInvoiceTypeSelectedState &&
                              state.type == InvoiceFilterType.LAST_3_DAYS) {
                            bgColor = AppColors.appGreenColor;
                          }
                          return FilterOptionButtonItemWidget(
                              bgColor: bgColor,
                              color: Colors.white,
                              text: "آخر ثلاثة أيام",
                              onClick: () {
                                invoiceCubit.getInvoiceLast3Days();
                              });
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      BlocBuilder<InvoiceCubit, ControlPanelState>(
                        buildWhen: (previous, current) =>
                            current is ChangeInvoiceTypeSelectedState,
                        builder: (context, state) {
                          var bgColor = Colors.black54;
                          if (state is ChangeInvoiceTypeSelectedState &&
                              state.type == InvoiceFilterType.ALLDAYS) {
                            bgColor = AppColors.appGreenColor;
                          }
                          return FilterOptionButtonItemWidget(
                            bgColor: bgColor,
                            color: Colors.white,
                            text: "جميع الأيام",
                            onClick: () {
                              invoiceCubit.getInvoice();
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: BlocBuilder<InvoiceCubit, ControlPanelState>(
                  buildWhen: (previous, current) => current is GetInvoiceState,
                  builder: (context, state) {
                    if (state is GetInvoiceState) {
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
                              invoiceCubit.getInvoice();
                            });
                      }

                      List<InvoiceModel>? data =
                          invoiceCubit.invoiceActions.getInvoice();
                      if (data.isEmpty) {
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
                                  getAppDataColumn('رمز الفاتورة'),
                                  getAppDataColumn('اسم العميل'),
                                  getAppDataColumn('الخصم على المجموع'),
                                  getAppDataColumn('المحموع'),
                                  getAppDataColumn('تاريخ البيع'),
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
                                      DataCell(BlocConsumer<InvoiceCubit,
                                          ControlPanelState>(
                                        listenWhen: (previous, current) =>
                                            current is GetInvoiceDetailsState &&
                                            current.invoiceId == data[index].id,
                                        buildWhen: (previous, current) =>
                                            current is GetInvoiceDetailsState &&
                                            current.invoiceId == data[index].id,
                                        listener: (context, state) {
                                          if (state is GetInvoiceDetailsState &&
                                              state.isLoaded) {
                                            if (state.isSuccess) {
                                              generateInvoiceFromInvoiceModels(
                                                  ivd: state.invoiceDetails,
                                                  invoice: data[index],
                                                pageContext: pageContext
                                              );
                                            } else {
                                              sl<ShowCustomMessage>().showCustomToast(
                                                  context: pageContext,
                                                  message: state.message,
                                                  bkgColor:
                                                      AppColors.appRedColor,
                                                  textColor: Colors.black,
                                              );
                                            }
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is GetInvoiceDetailsState &&
                                              !state.isLoaded) {
                                            return getAppProgress();
                                          }
                                          return IconButton(
                                              onPressed: () {
                                                invoiceCubit.getInvoiceDetails(
                                                    data[index].id);
                                              },
                                              icon: const Icon(Icons.print));
                                        },
                                      )),
                                      getAppDataCell(data[index].invoiceNumber),
                                      getAppDataCell(data[index].customerName),
                                      getAppDataCell(
                                          formatNumber(data[index].discount)),
                                      getAppDataCell(
                                          formatNumber(data[index].totalPrice)),
                                      getAppDataCell(getFormatedDate(
                                          data[index].createdAt.toDate())),
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
              ),
              BlocBuilder<InvoiceCubit, ControlPanelState>(
                buildWhen: (previous, current) =>
                    current is ChangeInvoiceTypeSelectedState,
                builder: (context, state) {
                  StringBuffer word = StringBuffer();
                  if (state is ChangeInvoiceTypeSelectedState) {
                    switch (state.type) {
                      case InvoiceFilterType.TODAY:
                        word.clear();
                        word.write("المحموع");
                        break;
                      case InvoiceFilterType.ALLDAYS:
                        word.clear();
                        word.write("المحموع");
                        break;
                      case InvoiceFilterType.LAST_2_DAYS:
                        word.clear();
                        word.write("المحموع");
                        break;
                      default:
                        word.clear();
                        word.write("المحموع ");
                        break;
                    }
                    return Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "$word ${formatNumber(state.totalPrice)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ));
                  }
                  return getAppProgress();
                },
              )
            ]));
  }
}
