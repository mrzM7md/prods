import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final List<dynamic> categoryIds;
  final double remainedQuantity;
  final double boughtQuantity;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final List<String>? categoriesNames;

  const ProductModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.categoryIds,
      required this.remainedQuantity,
      required this.boughtQuantity,
      required this.createdAt,
      required this.updatedAt,
      this.categoriesNames});

  factory ProductModel.fromDocument(Map<String, dynamic> document) {
    return ProductModel(
        id: document['id'],
        name: document['name'],
        price: double.parse(document['price'].toString()),
        categoryIds: document['categoryIds'],
        remainedQuantity: double.parse(document['remainedQuantity'].toString()),
        boughtQuantity: double.parse(document['boughtQuantity'].toString()),
        createdAt: document['createdAt'],
        categoriesNames: document['categoriesNames'],
        updatedAt: document['updatedAt']);
  }

  Map<String, dynamic> toDocument() => <String, dynamic>{
        "name": name,
        "price": price,
        "categoryIds": categoryIds,
        "remainedQuantity": remainedQuantity,
        "boughtQuantity": boughtQuantity,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "categoriesNames": categoriesNames,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        categoryIds,
        remainedQuantity,
        boughtQuantity,
        createdAt,
        updatedAt,
        categoriesNames,
      ];
}
