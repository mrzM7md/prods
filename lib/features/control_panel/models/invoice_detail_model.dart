import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InvoiceDetailModel extends Equatable {
  final String productId, productName;
  final double quantity;
  final int discountType;
  final double priceAfterDiscount, discount;
  final Timestamp createdAt;

  const InvoiceDetailModel({
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
      discount:  double.parse(map['discount'].toString()),
      createdAt: map['createdAt'],
      productName: map['productName'],
      priceAfterDiscount: double.parse(map['priceAfterDiscount'].toString()),
    );
  }

  @override
  List<Object?> get props => [productId, quantity, discountType, discount, createdAt, productName, priceAfterDiscount];
}