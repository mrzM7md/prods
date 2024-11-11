import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/carts_actions.dart';
import 'package:prods/features/control_panel/business/sections/products_actions.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

class CartsCubit extends ControlPanelCubit {
  final CartsActions cartActions;
  final ProductsActions productsActions;

  CartsCubit({required this.cartActions, required this.productsActions, required super.appActions});

  static CartsCubit get(context) => BlocProvider.of(context);

  addToCart(ProductModel product) {
    bool isAdded = cartActions.addToCart(product);
    if (isAdded) {
      emit(AddToCartState(productId: product.id, isSuccess: true, message: 'تم اضافة المنتج إلى السلة'));
    }
    else {
      emit(AddToCartState(productId: product.id, isSuccess: false, message: 'المنتج موجود مسبقا في السلة'));
    }
  }

  plusOneQuantityToItem(String productId) {
    cartActions.plusOneQuantityToItem(productId);
    emit(ChangeQuantityToItemAndAddDiscountState(productId: productId));
  }
  minusOneQuantityToItem(String productId) {
    cartActions.minusOneQuantityToItem(productId);
    emit(ChangeQuantityToItemAndAddDiscountState(productId: productId));
  }
  changeQuantityToItem(String productId, double newQuantity) {
    cartActions.changeQuantityToItem(productId, newQuantity);
    emit(ChangeQuantityToItemAndAddDiscountState(productId: productId));
  }
  addDiscountToItem(String productId, double discount) {
    cartActions.addDiscountToItem(productId, discount);
    emit(ChangeQuantityToItemAndAddDiscountState(productId: productId));
  }
  deleteItemFromCart(String productId) async {
    try{
      emit(DeleteItemFromCartState(productId: productId, isLoaded: false, message: ''));
      await cartActions.deleteItemFromCart(productId);
      List<ProductModel> products = await productsActions.getProductsByIds(cartActions.getCart().map((c) => c.productId).toList());
      emit(GetProductsByIdsState(products: products, isLoaded: true, message: "تم جلب المنتجات بنجاح", isSuccess: true));
    }
    catch(ex){
      // emit(DeleteItemFromCartState(productId: productId, isLoaded: false, message: ''));
    }
  }

  getProductsByIds(List<String> productsIds) async {
    emit(const GetProductsByIdsState(products: null, isLoaded: false, message: "", isSuccess: false));
    try{
      List<ProductModel> products = await productsActions.getProductsByIds(productsIds);
      emit(GetProductsByIdsState(products: products, isLoaded: true, message: "تم جلب المنتجات بنجاح", isSuccess: true));
    }
    catch(ex){
      emit(const GetProductsByIdsState(products: null, isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  changeCartQuantityAfterComa(CartQuantityAfterComa cartQuantityAfterComa, String id){
    emit(ChangeCartQuantityAfterComa(cartQuantityAfterComa: cartQuantityAfterComa, id: id));
  }

}