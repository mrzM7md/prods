import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as format_date;
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/features/control_panel/models/invoice_detail_model.dart';
import 'package:prods/features/control_panel/models/invoice_model.dart';

import '../../../../../../core/consts/app_colors.dart';
import '../../../../business/sections/invoice_cubit.dart';

OverlayEntry showCompleteSellInvoicePreparing(BuildContext pageContext, double totalPrice) {
  late OverlayEntry overlayEntry;
  InvoiceCubit invoiceCubit = InvoiceCubit.get(pageContext);
  CartsCubit cartsCubit = CartsCubit.get(pageContext);
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController addingDiscountOnTotalController = TextEditingController();
  overlayEntry = OverlayEntry(
    builder: (context) => Stack(
      children: [
        const ModalBarrier(
          dismissible: false, // منع إغلاق النافذة بالنقر خارجها
          color: Colors.black54, // لون الخلفية الشفافة
        ),
        Positioned(
          top: 200.0,
          left: MediaQuery.of(context).size.width * 0.2,
          width: MediaQuery.of(context).size.width / 2,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                        overlayEntry.remove();
                      },
                      icon: const Icon(Icons.close),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "إكمال إجراءات الفاتورة",
                      style: TextStyle(
                        fontSize: MediaQuery.sizeOf(context).width <= 400 ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Form(
                        key: key,
                        child: Column(
                          children: [
                            getAppTextField(text: "اسم العميل (اختياري)", onChange: (value){}, validator: (value){}, controller: customerNameController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.rtl, suffixIconButton: null,),
                            const SizedBox(height: 10,),
                            getAppTextField(
                              inputType: TextInputType.number,
                              text: " [${formatNumber(totalPrice)}] خصم إضافي على المحموع",
                              onChange: (value){
                                if (!RegExp(r'^\d*$').hasMatch(value)) {
                                  addingDiscountOnTotalController.text = value.replaceAll(RegExp(r'[^0-9]'), '');
                                  addingDiscountOnTotalController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: addingDiscountOnTotalController.text.length),
                                  );
                                }
                            }, validator: (value){
                                if(double.parse(value.toString()) > totalPrice){
                                  return "لا مبكن أن يكون الخصم أكبر من المبلغ نفسه!";
                                }
                                return null;
                            }, controller: addingDiscountOnTotalController, fillColor: AppColors.appGrey, obscureText: false, direction: TextDirection.ltr
                              , suffixIconButton: null,),
                          ],
                        ),
                    ),
                    const SizedBox(height: 20,),
                    getAppButton(
                      color: AppColors.appGreenColor,
                      textColor: Colors.white,
                      text: "إنشاء الفاتورة",
                      onClick: () async {
                        if(addingDiscountOnTotalController.text.isEmpty){
                        addingDiscountOnTotalController.text = "0.0";
                      }
                      if(key.currentState!.validate()){
                          overlayEntry.remove();
                          invoiceCubit.addNewInvoiceThenRemoveCart(context: pageContext, customerName: customerNameController.text, discount: double.parse(addingDiscountOnTotalController.text));
                          generateInvoiceFromInvoiceModels(ivd:
                          cartsCubit.cartActions.getCart().map(
                                  (c) => InvoiceDetailModel(
                                productId: c.productId,
                                quantity: c.quantity,
                                discountType: 0,
                                discount: c.discount,
                                createdAt: Timestamp.now(),
                                productName: c.product.name,
                                priceAfterDiscount: c.product.price - c.discount,
                              )
                          ).toList()
                              , invoice: InvoiceModel(
                                id: "",
                                customerName: customerNameController.text,
                                discount: double.parse(addingDiscountOnTotalController.text),
                                totalPrice: totalPrice - double.parse(addingDiscountOnTotalController.text),
                                invoicesDetailsIds: const [],
                                invoiceNumber: format_date.DateFormat('yyyyMMdd-HHmmss').format(DateTime.now()),
                                createdAt: Timestamp.now(),
                              ), pageContext: pageContext
                          );
                        }
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  // إدراج الـ OverlayEntry بعد إنشائه
  Overlay.of(pageContext).insert(overlayEntry);
  return  overlayEntry;
}


