import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

class CategoriesActions {

  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  final List<CategoryModel> _categories = [];
  List<CategoryModel> getCategories() => _categories;

  Future<List<CategoryModel>> getAllCategories() async {
    // print("One:");
    _categories.clear();
    QuerySnapshot snapshot = await (await getCategoriesReference()).orderBy('createdAt', descending: true).get();
    // print("Three:");
    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      _categories.add(CategoryModel.fromDocument(myDoc));
    }
    // print("This IS Cats: $categories");
    return _categories;
  }

  List<String> getCategoriesNamesFromIds(List<dynamic> categoriesIds) {
    List<String> categoriesNames = getCategories().where((element) => categoriesIds.contains(element.id)).map((e) => e.name).toList();
    return categoriesNames;
  }

  Future<CategoryModel> addNewCategory(CategoryModel newCategory) async {
    CollectionReference snapshot = await getCategoriesReference();
     snapshot.doc(newCategory.id).set(
        newCategory.toDocument()
   );

    return newCategory;
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
      var data = (await (await getCategoriesReference()).doc(id).get()).data();
      if(data != null){
        var name = await ( data as Map)["name"];
        catNames.add(name);
      }

      // print(name);
    }
    // print("I am here 2");
    return catNames;
  }

  Future<CollectionReference<Map<String, dynamic>>> getCategoriesReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    // print("Two:");
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("categories");
  }

}