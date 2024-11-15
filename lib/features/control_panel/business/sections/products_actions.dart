import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

class ProductsActions {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  List<ProductModel> _products = [];
  final List<String> _selectedCategoriesFilter = [];
  final List<String> _selectedCategoriesForProductAdding = [];
  SortProductType _productTypeFilter = SortProductType.FROM_NEWEST_TO_OLDERS;
  final StringBuffer _searchText = StringBuffer("");

  bool _isFilterOptionsVisible = false;
  getFilterOptionsVisibility() => _isFilterOptionsVisible;
  changeFilterOptionsVisibility()=> _isFilterOptionsVisible = !_isFilterOptionsVisible;

  Future<List<ProductModel>> getProductsByFilter(List<String> categoriesIds, SortProductType type, String searchText) async {
    // print("One:");
    QuerySnapshot snapshot;
    Query<Map<String, dynamic>> items;
    if(categoriesIds.isNotEmpty){
      items = (await getProductsReference())
          .where('categoryIds', arrayContainsAny: categoriesIds)
          // .where('name', isGreaterThanOrEqualTo: searchText)
          // .where('boughtQuantity', isGreaterThanOrEqualTo: searchText)
          // .where('remainedQuantity', isGreaterThanOrEqualTo: searchText)
      ;
    }else{
      items = (await getProductsReference());
    }

    // write cases
    // 1- from must selling to least
    // 2- from least selling to must
    // 3- from newest to oldest
    // 4- from oldest to newest

    switch(type){
      case SortProductType.FROM_MUST_SELLING_TO_LEAST:
        {
          snapshot = await items.orderBy('boughtQuantity', descending: true).get();
          break;
        }
      case SortProductType.FROM_LEAS_SELLING_TO_MUST:
        {
          snapshot = await items.orderBy("boughtQuantity", descending: false,
          ).get();
          break;
        }
      case SortProductType.FROM_NEWEST_TO_OLDERS:
        {
          snapshot = await items.orderBy("createdAt", descending: true,
          ).get();
          break;
        }
      case SortProductType.FROM_OLDEST_TO_NEWEST:
        {
          snapshot = await items.orderBy("createdAt", descending: false,
          ).get();
          break;
        }
    }

    // print("Three:");
    List<ProductModel> products = [];
    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      products.add(ProductModel.fromDocument(myDoc));
    }
    // print("This IS Cats: $products");
    return products.where((p) =>
      p.name.contains(searchText) ||
      p.boughtQuantity.toString().contains(searchText) ||
      p.remainedQuantity.toString().contains(searchText) ||
      p.price.toString().contains(searchText)
    ).toList();
  }

  Future<ProductModel?> getProductDetailById(String productId) async {
    var docSnapshot = await (await getProductsReference()).doc(productId).get();
    if (docSnapshot.exists) {
      var doc =  (docSnapshot.data() as Map<String, dynamic>);
      doc['id'] = docSnapshot.id;
      return ProductModel.fromDocument(doc);
    } else {
      return null;
    }
  }

  getProductsByIds(List<String> productsIds) async {
    // get products by its ids from firestore database
    var snapshot = await getProductsReference();
    List<ProductModel> products = [];
    for (var productId in productsIds) {
      var docSnapshot = await snapshot.doc(productId).get();
      if (docSnapshot.exists) {
        var doc =  (docSnapshot.data() as Map<String, dynamic>);
        doc['id'] = docSnapshot.id;
        products.add(ProductModel.fromDocument(doc));
      }
    }
    return products;
  }



  Future<ProductModel> addNewProduct(ProductModel newProduct) async {
    CollectionReference snapshot = await getProductsReference();

    await snapshot.doc(newProduct.id).set(
        newProduct.toDocument()
      );

    return newProduct;
    // snapshot
  }

  Future<ProductModel> editProduct(ProductModel productModel) async {
    CollectionReference snapshot = await getProductsReference();

    await snapshot.doc(productModel.id).update(
        productModel.toDocument()
    );

    return productModel;
    // snapshot
  }

  Future<ProductModel> deleteProduct(ProductModel productModel) async {
    CollectionReference snapshot = await getProductsReference();
    await snapshot.doc(productModel.id).delete();
    return productModel;
    // snapshot
  }

  //#### START PRODUCTS ACTION METHODS ###//
  Future<CollectionReference<Map<String, dynamic>>> getProductsReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    // print("Two:");
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("products");
  }

  addItemToProducts(ProductModel item) => _products.add(item);

  // editItemInProductById(String id, ProductModel item) => _products[index] = item;

  editItemInProductById(String id, ProductModel item) {
    int index = _products.indexWhere((p) => p.id == id);
    _products[index] = item;
  }

  removeItemByIndexFromProducts(int index) => _products.removeAt(index);

  List<String> getSelectedCategoriesFilter() => _selectedCategoriesFilter;
  addItemToSelectedCategoriesFilter(String catId) => _selectedCategoriesFilter.add(catId);
  removeItemFromSelectedCategoriesFilter(String catId) => _selectedCategoriesFilter.remove(catId);
  clearItemFromSelectedCategoriesFilter() => _selectedCategoriesFilter.clear();


  List<String> getSelectedCategoriesForProductAdding() => _selectedCategoriesForProductAdding;
  addItemToSelectedCategoriesForProductAddingFilter(String catId) => _selectedCategoriesForProductAdding.add(catId);
  removeItemFromSelectedCategoriesForProductAddingFilter(String catId) => _selectedCategoriesForProductAdding.remove(catId);
  clearItemFromSelectedCategoriesForProductAddingFilter() => _selectedCategoriesForProductAdding.clear();
  setCategoriesForProductEditing(List<String> catIds) {
    _selectedCategoriesForProductAdding.clear();
    _selectedCategoriesForProductAdding.addAll(catIds);
  }


  getSearchText() => _searchText.toString();
  setSearchText(String text) {
    _searchText.clear();
    _searchText.write(text);
  }

  getProductTypeFilter() => _productTypeFilter;
  changeProductTypeFilter(SortProductType type) => _productTypeFilter = type;

  setProducts(List<ProductModel> products) => _products = products;
  List<ProductModel> getProducts() => _products;

//#### START PRODUCTS ACTION METHODS ###//

}