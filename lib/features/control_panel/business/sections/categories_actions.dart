import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prods/features/control_panel/business/sections/products_actions.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

class CategoriesActions {
  final ProductsActions productsActions;

  CategoriesActions({required this.productsActions});

  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  Future<List<CategoryModel>> getAllCategories() async {
    // print("One:");
    QuerySnapshot snapshot = await (await getCategoriesReference()).orderBy('createdAt', descending: true).get();
    // print("Three:");
    List<CategoryModel> categories = [];
    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      categories.add(CategoryModel.fromDocument(myDoc));
    }
    // print("This IS Cats: $categories");
    return categories;
  }

  Future<CategoryModel> addNewCategory(String name, String id) async {
    // CollectionReference snapshot = await getCategoriesReference();
    CategoryModel categoryModel = CategoryModel(id: id, name: name, createdAt: Timestamp.now(), updatedAt: Timestamp.now());

   //  var x = await snapshot.doc(id).set(
   //      categoryModel.toDocument()
   // );

    var c = categoryModel.toDocument();
    return CategoryModel.fromDocument(c);
    // snapshot
  }


  Future<CategoryModel> editCategory(CategoryModel categoryModel) async {
    CollectionReference snapshot = await getCategoriesReference();

    await snapshot.doc(categoryModel.id).update(
        categoryModel.toDocument()
    );

    return categoryModel;
    // snapshot
  }

  Future<CategoryModel> deleteCategory(CategoryModel categoryModel) async {
    CollectionReference snapshot = await getCategoriesReference();
    await snapshot.doc(categoryModel.id).delete();
    return categoryModel;
    // snapshot
  }


  Future<List<String>> getCategoriesNamesFromIdsAsync(List<dynamic> catIds) async{
    List<String> catNames = [];
    for(var id in catIds){
      var name = await ( (await (await getCategoriesReference()).doc(id).get()).data() as Map)["name"];
      catNames.add(name);
      // print(name);
    }
    // print("I am here 2");
    return catNames;
  }

  Future<int> countOfProductToSpecificCategory(String categoryId) async {
    int productsCount = 0;
    QuerySnapshot snapshot = await (await productsActions.getProductsReference()).get();
    for(var doc in snapshot.docs){
      var cats = ((doc.data() as Map<String, dynamic>)["categoryIds"] as List);
      if(cats.contains(categoryId)){
        ++productsCount;
      }
    }
    return productsCount;
  }



  Future<CollectionReference<Map<String, dynamic>>> getCategoriesReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    // print("Two:");
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("categories");
  }

}