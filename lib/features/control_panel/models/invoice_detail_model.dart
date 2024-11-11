import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceDetailModel {
  final String productId, productName;
  final double quantity;
  final int discountType;
  final double priceAfterDiscount, discount;
  final Timestamp createdAt;

  InvoiceDetailModel({
    required this.productId,
    required this.quantity,
    required this.discountType,
    required this.discount,
    required this.createdAt,
    required this.productName,
    required this.priceAfterDiscount,
  });

  Map<String, dynamic> toDocument() {
    return {
      'productId': productId,
      'quantity': quantity,
      'discountType': discountType,
      'discount': discount,
      'createdAt': createdAt,
      'productName': productName,
      'priceAfterDiscount': priceAfterDiscount,
    };
  }

  factory InvoiceDetailModel.fromDocument(Map<String, dynamic> map) {
    return InvoiceDetailModel(
      productId: map['productId'],
      quantity: double.parse(map['quantity'].toString()),
      discountType: map['discountType'],
      discount: map['discount'],
      createdAt: map['createdAt'],
      productName: map['productName'],
      priceAfterDiscount: map['priceAfterDiscount'],
    );
  }
}