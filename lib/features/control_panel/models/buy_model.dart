import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BuyModel extends Equatable{
  final String id, name, unit;
  final double quantity, priceOfBuy, priceOfSell;

  final Timestamp createdAt, updatedAt;

  const BuyModel({required this.id, required this.name, required this.unit, required this.quantity, required this.priceOfBuy, required this.priceOfSell, required this.createdAt, required this.updatedAt});

  factory BuyModel.fromDocument(Map<String, dynamic> data){
    return BuyModel(
      id: data['id'],
      name: data['name'],
      unit: data['unit'],
      quantity: double.parse(data['quantity'].toString()),
      priceOfBuy: double.parse(data['priceOfBuy'].toString()),
      priceOfSell: double.parse(data['priceOfSell'].toString()),
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'priceOfBuy': priceOfBuy,
      'priceOfSell': priceOfSell,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [id, name, unit, quantity, priceOfBuy, priceOfSell, createdAt, updatedAt];
}