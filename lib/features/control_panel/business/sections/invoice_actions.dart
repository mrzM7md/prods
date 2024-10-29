import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:prods/features/control_panel/business/sections/carts_actions.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/features/control_panel/business/sections/products_actions.dart';
import 'package:prods/features/control_panel/models/invoice_detail_model.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

import '../../models/invoice_model.dart';

class InvoiceActions {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CartsActions cartsActions;
  final ProductsActions productsActions;

  InvoiceActions({required this.cartsActions, required this.productsActions});

  final List<InvoiceModel> _invoices = [];
  List<InvoiceModel> getInvoice() => _invoices;

  Future<void> getInvoicesFromDatabase() async {
    _invoices.clear();

    // جلب الفواتير بترتيب تنازلي حسب تاريخ الإنشاء
    QuerySnapshot snapshot = await (await getInvoicesReference())
        .orderBy('createdAt', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }


  Future<void> getInvoicesOnlyTodayFromDatabase() async {
    _invoices.clear();

    // تحديد بداية اليوم عند الساعة 12 صباحًا
    DateTime startOfDay = DateTime.now();
    startOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 0, 0, 0);

    // تحديد نهاية اليوم عند الساعة 11:59 مساءً
    DateTime endOfDay = DateTime.now();
    endOfDay = DateTime(endOfDay.year, endOfDay.month, endOfDay.day, 23, 59, 59);

    QuerySnapshot snapshot = await (await getInvoicesReference())
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('createdAt', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }


  // getInvoicesOnlyTodayFromDatabase() async {
  //   _invoices.clear();
  //   QuerySnapshot snapshot = await (await getInvoicesReference()).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(days: 1))).get();
  //   for(var doc in snapshot.docs) {
  //     var myDoc = (doc.data() as Map<String, dynamic>);
  //     myDoc['id'] = doc.id;
  //     _invoices.add(InvoiceModel.fromDocument(myDoc));
  //   }
  // }


  Future<double> getTotalPriceOfInvoice() async {
  double totalPrice = 0;
    for (var i = 0; i < getInvoice().length; i++) {
      totalPrice += getInvoice()[i].totalPrice;
    }
    return totalPrice;
}


  Future<void> getInvoicesOnlyAtLastTwoDaysFromDatabase() async {
    _invoices.clear();

    // تحديد بداية اليوم عند الساعة 12 صباحًا قبل يومين
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
    startOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 0, 0, 0);

    // تحديد نهاية اليوم عند الساعة 11:59 مساءً اليوم
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot snapshot = await (await getInvoicesReference())
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('createdAt', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }

  // getInvoicesOnlyAtLastTwoDaysFromDatabase() async {
  //   _invoices.clear();
  //   Que rySnapshot snapshot = await (await getInvoicesReference()).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(days: 2))).get();
  //   for(var doc in snapshot.docs) {
  //     var myDoc = (doc.data() as Map<String, dynamic>);
  //     myDoc['id'] = doc.id;
  //     _invoices.add(InvoiceModel.fromDocument(myDoc));
  //   }
  // }



  Future<void> getInvoicesOnlyAtLastThreeDaysFromDatabase() async {
    _invoices.clear();

    // تحديد بداية اليوم عند الساعة 12 صباحًا قبل يومين
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 2));
    startOfDay = DateTime(startOfDay.year, startOfDay.month, startOfDay.day, 0, 0, 0);

    // تحديد نهاية اليوم عند الساعة 11:59 مساءً اليوم
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    QuerySnapshot snapshot = await (await getInvoicesReference())
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('createdAt', descending: true)
        .get();

    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }

  // getInvoicesOnlyAtLastThreeDaysFromDatabase() async {
  //   _invoices.clear();
  //   QuerySnapshot snapshot = await (await getInvoicesReference()).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(days: 2))).get();
  //   for(var doc in snapshot.docs) {
  //     var myDoc = (doc.data() as Map<String, dynamic>);
  //     myDoc['id'] = doc.id;
  //     _invoices.add(InvoiceModel.fromDocument(myDoc));
  //   }
  // }

  getInvoicesOnlyAtLastWeekFromDatabase() async {
    _invoices.clear();
    QuerySnapshot snapshot = await (await getInvoicesReference()).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(days: 7))).get();
    for(var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }

  getInvoicesOnlyAtLastMonthFromDatabase() async{
    _invoices.clear();
    QuerySnapshot snapshot = await (await getInvoicesReference()).where('createdAt', isGreaterThan: DateTime.now().subtract(const Duration(days: 30))).get();
    for(var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _invoices.add(InvoiceModel.fromDocument(myDoc));
    }
  }



  final List<String> _invoiceDetailsIds = [];
  clearInvoiceDetailsIds() => _invoiceDetailsIds.clear();

  late WriteBatch _batch;
  late int _remainedQuantity, _boughtQuantity;
  late CollectionReference _invoiceColRef;
  late CollectionReference _productColRef;

  addNewInvoice(BuildContext context, String customerName, double discount) async {
    clearInvoiceDetailsIds();
    _batch = firestore.batch();
    _invoiceColRef = await getInvoicesDetailsReference();
    _productColRef = await productsActions.getProductsReference();
    for (var item in cartsActions.getCart()) {
        var invoiceRef = _invoiceColRef.doc();
        _batch.set(invoiceRef, InvoiceDetailModel(
            productId: item.productId,
            quantity: item.quantity,
            discountType: 0,
            discount: item.discount,
            createdAt: Timestamp.now(),
            productName: item.product.name,
            priceAfterDiscount: item.product.price - item.discount
        ).toDocument());

        var productRef = _productColRef.doc(item.productId);
        _remainedQuantity = item.product.remainedQuantity - item.quantity;
        _boughtQuantity = item.product.boughtQuantity + item.quantity;

        _batch.update(productRef, {
          "remainedQuantity" : _remainedQuantity,
          "boughtQuantity" : _boughtQuantity,
        });

        // print remainedQuantity and quantity and boughtQuantity
        // print("remainedQuantity: ${item.product.remainedQuantity}, boughtQuantity: ${item.product.boughtQuantity}, quantity: ${item.quantity}");  // it prints remainedQuantity and boughtQuantity and quantity of the item that was bought
        // print("---------------------------------------------");  // it prints a separator line for each item that was bought  // you can remove this line if you don't want a separator line between items

        cartsActions.updateProductInfo(item.productId, ProductModel(id: item.productId, name: item.product.name, price: item.product.price, categoryIds: item.product.categoryIds, remainedQuantity: _remainedQuantity, boughtQuantity: _boughtQuantity, createdAt: item.product.createdAt, updatedAt: item.product.updatedAt));
        // print("Remined:: $_remainedQuantity");

          // if(_remainedQuantity == 0){
          //   cartsActions.deleteItemFromCart(item.productId);
          // }

          if(_remainedQuantity <= item.quantity){
            cartsActions.updateItemQuantity(item.productId, _remainedQuantity);
          }

        _invoiceDetailsIds.add(invoiceRef.id);
      }

      var invoiceRef =  (await getInvoicesReference()).doc();
      _batch.set(invoiceRef, InvoiceModel(
          id: "",
          customerName: customerName,
          discount: discount,
          totalPrice: cartsActions.getTotalPrice() - discount,
          invoicesDetailsIds: _invoiceDetailsIds,
          invoiceNumber: DateFormat('yyyyMMdd-HHmmss').format(DateTime.now()),
          createdAt: Timestamp.now(),
      ).toDocument());
    CartsCubit.get(context).getProductsByIds(
      CartsCubit.get(context).cartActions.getCart().map((c) => c.productId).toList(),
    );
      await _batch.commit();

  }


  getInvoiceDetails(String invoiceId) async {
    // first get invoiceDetailsIds from invoice by invoice id using getInvoice method..
     InvoiceModel? invoice = getInvoice().firstWhereOrNull((i) => i.id == invoiceId);
     if(invoice == null) {
      return null;
    }
    var invoiceDetailsIds = invoice.invoicesDetailsIds;
     List<InvoiceDetailModel> invoiceDetails = [];
     for (var detailId in invoiceDetailsIds) {
       var detail = await (await getInvoicesDetailsReference()).doc(detailId).get();
       invoiceDetails.add(InvoiceDetailModel.fromDocument(detail.data() as Map<String, dynamic>));
     }
     return invoiceDetails;
  }

  Future<CollectionReference<Map<String, dynamic>>> getInvoicesReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    // print("Two:");
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("invoices");
  }

  Future<CollectionReference<Map<String, dynamic>>> getInvoicesDetailsReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    // print("Two:");
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("invoicesDetails");
  }




}