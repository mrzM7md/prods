import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_option_button_Item_widget.dart';

import '../../../../../../core/consts/app_colors.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../business/control_panel_cubit.dart';
import '../../../../business/sections/invoice_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class FilterInvoicesByDateToData extends StatelessWidget {
  const FilterInvoicesByDateToData({super.key});

  @override
  Widget build(BuildContext context) {
    InvoiceCubit invoiceCubit = InvoiceCubit.get(context);
    return Container(
      padding: const EdgeInsetsDirectional.all(5),
      child: Column(
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.close)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<InvoiceCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is ChangeInvoiceTypeSelectedState,
                builder: (context, state) {
                  var bgColor = Colors.black54;
                  if (state is ! ChangeInvoiceTypeSelectedState) {
                    bgColor = AppColors.appGreenColor;
                  }
                  if (state is ChangeInvoiceTypeSelectedState &&
                      state.type ==
                          InvoiceFilterType.TODAY) {
                    bgColor = AppColors.appGreenColor;
                  }
                  return FilterOptionButtonItemWidget(
                      bgColor: bgColor,
                      color: Colors.white,
                      text: "من",
                      onClick: () {
                        invoiceCubit.getInvoiceToday();
                      });
                },),
              const SizedBox(
                width: 5,
              ),
              BlocBuilder<InvoiceCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is ChangeInvoiceTypeSelectedState,
                builder: (context, state) {
                  var bgColor = Colors.black54;
                  // if (state is ChangeInvoiceTypeSelectedState &&
                  //     state.type ==
                  //         InvoiceFilterType.SPECIAL) {
                  //   bgColor = AppColors.appGreenColor;
                  // }
                  return FilterOptionButtonItemWidget(
                      bgColor: bgColor,
                      color: Colors.white,
                      text: "إلى",
                      onClick: () {
                        // invoiceCubit.changeInvoiceTypeSelected(
                        //     InvoiceFilterType.SPECIAL);
                      });
                },
              ),
            ],
          ),
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.now(),
            locale: "ar",
            lastDay: DateTime(DateTime.now().year + 20, 1, 1),
            headerStyle: const HeaderStyle(
                titleCentered: true, formatButtonVisible: false),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              // cubit.changeChoseDay(DateTime(selectedDay.year, selectedDay.month, selectedDay.day, ));
            },
          )
        ],
      ),
    );
  }
}
