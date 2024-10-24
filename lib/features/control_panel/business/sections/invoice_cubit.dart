import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/features/control_panel/business/sections/invoice_actions.dart';
import 'package:prods/features/control_panel/models/invoice_detail_model.dart';
import '../../../../core/enums/enums.dart';
import '../control_panel_cubit.dart';

class InvoiceCubit extends ControlPanelCubit {
  final InvoiceActions invoiceActions;
  InvoiceCubit({required this.invoiceActions});
  static InvoiceCubit get(context) => BlocProvider.of(context);


  addNewInvoiceThenRemoveCart({required String customerName, required double discount}) async {
    try {
      emit(const AddInvoiceState(isSuccess: false, message: "", isLoaded: false));
      invoiceActions.addNewInvoice(customerName, discount);
      emit(const AddInvoiceState(isSuccess: true, message: "تم إنشاء فاتورة جديدة بنجاح", isLoaded: true));
    } catch (e) {
      emit(const AddInvoiceState(isSuccess: false, message: "خدمة الفاتورة غير متاحة", isLoaded: true));
    }
  }

  getInvoice() async {
    emit(GetInvoiceState(isLoaded: false, message: "", isSuccess: false));
    try{
      await invoiceActions.getInvoicesFromDatabase();
      emit(GetInvoiceState(isLoaded: true, message: "تم جلب الفواتير بنجاح", isSuccess: true));
      await Future.delayed(const Duration(microseconds: 300));
      double totalPrice = await invoiceActions.getTotalPriceOfInvoice();
      emit(ChangeInvoiceTypeSelectedState(type: InvoiceFilterType.ALLDAYS, totalPrice: totalPrice));

    }catch(ex){
      emit(GetInvoiceState(isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  getInvoiceToday() async {
    emit(GetInvoiceState(isLoaded: false, message: "", isSuccess: false));
    try{
      await invoiceActions.getInvoicesOnlyTodayFromDatabase();
      emit(GetInvoiceState(isLoaded: true, message: "تم جلب الفواتير بنجاح", isSuccess: true));
      await Future.delayed(const Duration(microseconds: 300));
      double totalPrice = await invoiceActions.getTotalPriceOfInvoice();
      emit(ChangeInvoiceTypeSelectedState(type: InvoiceFilterType.TODAY, totalPrice: totalPrice));
    }catch(ex){
      emit(GetInvoiceState(isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  getInvoiceLast2Days() async {
    emit(GetInvoiceState(isLoaded: false, message: "", isSuccess: false));
    try{
      await invoiceActions.getInvoicesOnlyAtLastTwoDaysFromDatabase();
      emit(GetInvoiceState(isLoaded: true, message: "تم جلب الفواتير بنجاح", isSuccess: true));
      await Future.delayed(const Duration(microseconds: 300));
      double totalPrice = await invoiceActions.getTotalPriceOfInvoice();
      emit(ChangeInvoiceTypeSelectedState(type: InvoiceFilterType.LAST_2_DAYS, totalPrice: totalPrice));
    }catch(ex){
      emit(GetInvoiceState(isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  getInvoiceLast3Days() async {
    emit(GetInvoiceState(isLoaded: false, message: "", isSuccess: false));
    try{
      await invoiceActions.getInvoicesOnlyAtLastThreeDaysFromDatabase();
      emit(GetInvoiceState(isLoaded: true, message: "تم جلب الفواتير بنجاح", isSuccess: true));
      await Future.delayed(const Duration(microseconds: 300));
      double totalPrice = await invoiceActions.getTotalPriceOfInvoice();
      emit(ChangeInvoiceTypeSelectedState(type: InvoiceFilterType.LAST_3_DAYS, totalPrice: totalPrice));
    }catch(ex){
      emit(GetInvoiceState(isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  changeInvoiceTypeSelected(InvoiceFilterType type) async {
    double totalPrice = await invoiceActions.getTotalPriceOfInvoice();
    emit(ChangeInvoiceTypeSelectedState(type: type, totalPrice: totalPrice));
  }

  getInvoiceDetails(String invoiceId) async {
    emit(GetInvoiceDetailsState(isLoaded: false, message: "", isSuccess: false, invoiceDetails: [], invoiceId: invoiceId));
    try{
      List<InvoiceDetailModel>? invoiceDetails = await invoiceActions.getInvoiceDetails(invoiceId);
      emit(GetInvoiceDetailsState(isLoaded: true, message: "تم جلب تفاصيل الفاتورة بنجاح", isSuccess: true, invoiceDetails: invoiceDetails ?? [], invoiceId: invoiceId));
    }catch(ex){
      emit(GetInvoiceDetailsState(isLoaded: true, message: "حدث خطأ ما", isSuccess: false, invoiceDetails: [], invoiceId: invoiceId));
    }
  }


}

