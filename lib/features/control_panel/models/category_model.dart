import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id, name;
  final Timestamp createdAt, updatedAt;

  const CategoryModel({required this.id, required this.name, required this.createdAt, required this.updatedAt});

  @override
  List<Object?> get props => [id, name, createdAt, updatedAt];

  factory CategoryModel.fromDocument(Map<String, dynamic> document){
    return CategoryModel(id: document['id'], name: document['name'], createdAt: document['createdAt'], updatedAt: document['updatedAt']);
  }

  Map<String, dynamic> toDocument() => <String, dynamic>{
    "name": name,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}