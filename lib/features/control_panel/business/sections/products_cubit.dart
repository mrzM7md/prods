import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/core/services/services_locator.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_actions.dart';
import 'package:prods/features/control_panel/business/sections/products_actions.dart';
import 'package:prods/features/control_panel/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductsCubit extends ControlPanelCubit {
  final ProductsActions productsActions;
  final CategoriesActions categoriesActions;
  ProductsCubit({required this.productsActions, required this.categoriesActions, required super.appActions});

  static ProductsCubit get(context) => BlocProvider.of(context);

  setNewItemIntoProducts(ProductModel product) {
    productsActions.addItemToProducts(product);
    emit(GetAllProductsState(products: productsActions.getProducts(), isLoaded: true, message: "ام جلب المنتجات نجاح", isSuccess: true));
  }

  editItemIntoProducts(ProductModel product) async {
    await productsActions.editItemInProductById(product.id, product);
    emit(GetAllProductsState(products: productsActions.getProducts(), isLoaded: true, message: "ام جلب المنتجات نجاح", isSuccess: true));
  }

  removeItemByIndexFromProducts(int index){
    productsActions.removeItemByIndexFromProducts(index);
    emit(GetAllProductsState(products: productsActions.getProducts(), isLoaded: true, message: "ام جلب المنتجات نجاح", isSuccess: true));
  }

  getProductDetailById(String productId) async {
    emit(GetProductDetailState(productModel: null, isLoaded: false, message: "", isSuccess: false));
    try{
      ProductModel? productModel = await productsActions.getProductDetailById(productId);
      if(productModel != null){
        emit(GetProductDetailState(productModel: productModel, isLoaded: true, message: "تم جلب تفاصيل المنتج بنجاح", isSuccess: true));
      }
      else{
        emit(GetProductDetailState(productModel: productModel, isLoaded: true, message: "المنتح غير موجود", isSuccess: false));
      }
    }catch(ex){
      print("حدث خطأ ما: $ex");
      emit(GetProductDetailState(productModel: null, isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  void getAllProductsByFilter(String searchText) async {
    emit(const GetAllProductsState(products: null, isLoaded: false, message: "", isSuccess: true));
    try{
      productsActions.setSearchText(searchText);
      productsActions.setProducts(
          await productsActions.getProductsByFilter(
              productsActions.getSelectedCategoriesFilter(),
              productsActions.getProductTypeFilter(),
              productsActions.getSearchText(),
          ));
      emit(GetAllProductsState(products: productsActions.getProducts(), isLoaded: true, message: "تم جلب جميع المنجات نجاح", isSuccess: true));
    }
    catch(ex){
      print("حدث خطأ ما عند جلب المنتجات بلفلنروة:::: $ex");
      emit(const GetAllProductsState(products: null, isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }


  addNewProduct(ProductModel newProduct) async {
    try{
      productsActions.addNewProduct(newProduct);
      emit(AddEditProductState(productModel: newProduct, isLoaded: true, isSuccess: true, message: "تم إضافة منتج جديد بنجاح"));
      setNewItemIntoProducts(newProduct);
    }catch(ex){
      print("حدث خطأ ما عند إضافة منتج: $ex");
      emit(const AddEditProductState(productModel: null, isLoaded: true, isSuccess: true, message: "حدث خطأ ما"));
    }
  }

  bool _isClickedOnAddNewOrEditProduct = false;
  bool getIsClickedOnAddNewProduct() => _isClickedOnAddNewOrEditProduct;
  changeClickedOnAddNewOrEditProduct({ProductModel? product, int? index}){
    _isClickedOnAddNewOrEditProduct = !getIsClickedOnAddNewProduct();
    emit(ChangeAddNewOrEditProductBoxState(isClickedOnAddNewProduct: getIsClickedOnAddNewProduct(), product: product, index: index));
  }

  
  editProduct(ProductModel editedProduct) async {
    emit(const AddEditProductState(productModel: null, isLoaded: false, isSuccess: false, message: ""));
    try{
      productsActions.editProduct(editedProduct);
      emit(AddEditProductState(productModel: editedProduct, isLoaded: true, isSuccess: true, message: "تم التعديل بنجاح"));
      await Future.delayed((const Duration(milliseconds: 200)));
      editItemIntoProducts(editedProduct);
    }catch(ex){
      emit(const AddEditProductState(productModel: null, isLoaded: true, isSuccess: false, message: "حدث خطأ ما"));
    }
  }

  getProductTypeSelected(){
    emit(GetSortProductTypeSelectedState(type: productsActions.getProductTypeFilter()));
  }

  clearAllCategoriesSelected(String searchText){
    productsActions.clearItemFromSelectedCategoriesFilter();
    getAllProductsByFilter(searchText);
    emit(GetSelectedCategoriesFiltersState(catIds: productsActions.getSelectedCategoriesFilter()));
  }

  setCategoriesForProductEditing(List<String> catIds) async {
    await Future.delayed(const Duration(milliseconds: 500));
    productsActions.setCategoriesForProductEditing(catIds);

    emit(GetSelectedCategoriesForProductAddingState(catIds: productsActions.getSelectedCategoriesForProductAdding()));
  }

  selectNewCategoryOrUnSelectForProductAdding(String catId){
    if(productsActions.getSelectedCategoriesForProductAdding().contains(catId)){
      productsActions.removeItemFromSelectedCategoriesForProductAddingFilter(catId);
    }
    else{
      productsActions.addItemToSelectedCategoriesForProductAddingFilter(catId);
    }
    emit(GetSelectedCategoriesForProductAddingState(catIds: productsActions.getSelectedCategoriesForProductAdding()));
  }

  selectNewCategoryOrUnSelect(String catId, String searchText){
  if(productsActions.getSelectedCategoriesFilter().contains(catId)){
      productsActions.removeItemFromSelectedCategoriesFilter(catId);
    }
    else{
      productsActions.addItemToSelectedCategoriesFilter(catId);
    }
    emit(GetSelectedCategoriesFiltersState(catIds: productsActions.getSelectedCategoriesFilter()));
    getAllProductsByFilter(searchText);
  }

  changeSortProductTypeSelected(SortProductType sortType, String searchText){
    emit(GetSortProductTypeSelectedState(type: sortType));
    productsActions.changeProductTypeFilter(sortType);
    SortProductType typeSelected = productsActions.getProductTypeFilter();
    switch(typeSelected){
      case SortProductType.FROM_NEWEST_TO_OLDERS:
        {
          productsActions
              .getProducts()
              .sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          break;
        }
      case SortProductType.FROM_OLDEST_TO_NEWEST:
        {
          productsActions
              .getProducts()
              .sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
          break;
        }
      case SortProductType.FROM_MUST_SELLING_TO_LEAST:
        {
          productsActions
              .getProducts()
              .sort((a, b) => b.boughtQuantity.compareTo(a.boughtQuantity));
          break;
        }
      case SortProductType.FROM_LEAS_SELLING_TO_MUST:
        {
          productsActions
              .getProducts()
              .sort((a, b) => a.boughtQuantity.compareTo(b.boughtQuantity));
          break;
        }
    }

    emit(GetAllProductsState(products: productsActions.getProducts().where(
        (p) =>
            p.name.contains(searchText) ||
            p.boughtQuantity.toString().contains(searchText) ||
            getFormatedDate(p.createdAt.toDate()).contains(searchText) ||
            getFormatedDate(p.updatedAt.toDate()).contains(searchText) ||
            p.price.toString().contains(searchText) ||
            p.remainedQuantity.toString().contains(searchText)
    ).toList(),
        isLoaded: true, isSuccess: true, message: "تم جلب البيانات مع ترتيبها بنجاح"));
  }
  
  deleteProduct(int index, ProductModel product) async {
    emit(DeleteProductState(productModel: product, isLoaded: false, isSuccess: false, message: ""));
    try{
      productsActions.deleteProduct(product);
      emit(DeleteProductState(productModel: product, isLoaded: true, isSuccess: true, message: "تم الحذف بنجاح"));
      /// This Must Be..
      await Future.delayed(const Duration(seconds: 1));
      removeItemByIndexFromProducts(index);
    }catch(ex){
      emit(DeleteProductState(productModel: product, isLoaded: true, isSuccess: false, message: "حدث خطأ ما"));
    }
  }

  changeFilterOptions(){
    productsActions.changeFilterOptionsVisibility();
    emit(ChangeFilterOptionsState());
  }
}