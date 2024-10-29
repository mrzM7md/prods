import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_actions.dart';
import 'package:prods/features/control_panel/models/category_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/services_locator.dart';

class CategoriesCubit extends ControlPanelCubit {
  final CategoriesActions categoriesActions;
  CategoriesCubit({required this.categoriesActions, required super.appActions});

  static CategoriesCubit get(context) => BlocProvider.of(context);


  List<CategoryModel> _categories = [];
  setNewItemIntoCategories(CategoryModel category) {
    _categories.add(category);
    emit(GetAllCategoriesState(categories: getCategories(), isLoaded: true, message: "ام جلب الأصنافب نجاح", isSuccess: true));
  }
  editItemInsideCategories(int index, CategoryModel category){
    _categories[index] = category;
    emit(GetAllCategoriesState(categories: getCategories(), isLoaded: true, message: "ام جلب الأصنافب نجاح", isSuccess: true));
  }

  removeItemByIndexFromCategories(int index){
    _categories.removeAt(index);
    emit(GetAllCategoriesState(categories: getCategories(), isLoaded: true, message: "ام جلب الأصنافب نجاح", isSuccess: true));
  }

  setCategories(List<CategoryModel> categories) => _categories = categories;
  List<CategoryModel> getCategories() => _categories;
  
  void getAllCategories() async {
    emit(const GetAllCategoriesState(categories: null, isLoaded: false, message: "", isSuccess: true));
    try{
      setCategories(await categoriesActions.getAllCategories());
      emit(GetAllCategoriesState(categories: getCategories(), isLoaded: true, message: "ام جلب الأصنافب نجاح", isSuccess: true));
    }
    catch(ex){
      print("EEEEEEEEEEEEEEEE:::: $ex");
      emit(const GetAllCategoriesState(categories: null, isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }


  
  addNewCategory(String name) async {
    emit(const AddEditCategoryState(isLoaded: false, isSuccess: false, message: ""));
    String id = "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    try{
      CategoryModel categoryModel;
        categoryModel = CategoryModel(id: id, name: name, createdAt: Timestamp.now(), updatedAt: Timestamp.now());
        categoriesActions.addNewCategory(name, id);

      setNewItemIntoCategories(categoryModel);
      emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "تم إضافة صنف جديد بنجاح"));
    }catch(ex){
      emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "حدث خطأ ما"));
    }
  }

  // addNewCategory(String name) async {
  //   emit(const AddEditCategoryState(isLoaded: false, isSuccess: false, message: ""));
  //   try {
  //     if(getConnectivityState() == ConnectivityState.OFFLINE){
  //       categoriesActions.addNewCategory(name);
  //       getAllCategories();
  //       emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "تم إضافة صنف جديد بنجاح"));
  //       return;
  //     }
  //     CategoryModel categoryModel = await categoriesActions.addNewCategory(name);
  //     emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "تم إضافة صنف جديد بنجاح"));
  //     setNewItemIntoCategories(categoryModel);
  //   } catch (ex) {
  //     emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "حدث خطأ ما"));
  //   }
  // }


  bool _isClickedOnAddNewOrEditCategory = false;
  bool getIsClickedOnAddNewCategory() => _isClickedOnAddNewOrEditCategory;
  changeClickedOnAddNewOrEditCategory({CategoryModel? category, int? index}){
    _isClickedOnAddNewOrEditCategory = !getIsClickedOnAddNewCategory();
    emit(ChangeAddNewOrEditCategoryBoxState(isClickedOnAddNewCategory: getIsClickedOnAddNewCategory(), category: category, index: index));
  }

  
  editCategory(int index, CategoryModel editedCategory) async {
    emit(const AddEditCategoryState(isLoaded: false, isSuccess: false, message: ""));
    try{
      categoriesActions.editCategory(editedCategory);
      emit(const AddEditCategoryState(isLoaded: true, isSuccess: true, message: "تم التعديل بنجاح"));
      editItemInsideCategories(index, editedCategory);
    }catch(ex){
      emit(const AddEditCategoryState(isLoaded: true, isSuccess: false, message: "حدث خطأ ما"));
    }
  }

  
  deleteCategory(int index, CategoryModel category) async {
    emit(DeleteCategoryState(categoryModel: category, isLoaded: false, isSuccess: false, message: ""));
    try{
        categoriesActions.deleteCategory(category);
        // We not neede this line because 'Future method' will not take any time
        emit(DeleteCategoryState(categoryModel: category, isLoaded: true, isSuccess: true, message: "تم الحذف بنجاح"));
        /// This Must Be..
        await Future.delayed(const Duration(seconds: 1));
        removeItemByIndexFromCategories(index);
        return;
        
    }catch(ex){
      emit(DeleteCategoryState(categoryModel: category, isLoaded: true, isSuccess: false, message: "حدث خطأ ما"));
    }
  }
}