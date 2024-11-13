import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InvoiceModel extends Equatable {
  final String id, customerName;
  final double discount, totalPrice;
  final List<dynamic> invoicesDetailsIds;
  final String invoiceNumber;
  final Timestamp createdAt;

  const InvoiceModel({
    required this.id,
    required this.customerName,
    required this.discount,
    required this.totalPrice,
    required this.invoicesDetailsIds,
    required this.invoiceNumber,
    required this.createdAt,
  });

  factory InvoiceModel.fromDocument(Map<String, dynamic> data){
    return InvoiceModel(
      id: data['id'],
      customerName: data['customerName'],
      discount: data['discount'],
      totalPrice: data['totalPrice'],
      invoiceNumber: data['invoiceNumber'],
      invoicesDetailsIds: data['invoicesDetailsIds'] ?? [],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toDocument() => {
    'customerName': customerName,
    'discount': discount,
    'totalPrice': totalPrice,
    'invoicesDetailsIds': invoicesDetailsIds,
    'invoiceNumber': invoiceNumber,
    'createdAt': createdAt,
  };

  @override
  List<Object?> get props => [id, customerName, discount, totalPrice, invoicesDetailsIds, invoiceNumber];
}
