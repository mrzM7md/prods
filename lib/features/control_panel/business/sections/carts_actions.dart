import 'package:prods/features/control_panel/models/cart_model.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

class CartsActions {
  final List<CartModel> _cart = [];
  final List<String> _cartProductsIdsHasOneQuantity = [];
  List<CartModel> getCart() {

    _cartProductsIdsHasOneQuantity.clear();
    _cartProductsIdsHasOneQuantity.addAll(
      _cart.where((c) => c.quantity < 1).map((cart) => cart.productId).toList()
    );

    for (var id in _cartProductsIdsHasOneQuantity) {
      _cart.removeWhere((c) => c.productId == id);
    }
    return _cart;
  }

  bool addToCart(ProductModel product) {
    if (! idThereProductInCart(product.id)) {
      _cart.add(CartModel(product.id, 1, 0, product));
      return true;
    }
    return false;
  }

  double getPriceBeforeDiscountAndQuantity(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      return _cart[cartIndex].product.price;
    }
    return 0;
  }

  getQuantity(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);

    if(cartIndex != -1){
      return _cart[cartIndex].quantity;
    }
    return 0;
  }

  double getDiscount(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);

    if(cartIndex != -1){
      return _cart[cartIndex].discount;
    }
    return 0;
  }

  double getPriceAfterDiscount(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);

    if(cartIndex != -1){
      return _cart[cartIndex].product.price - _cart[cartIndex].discount;
    }
    return 0;
  }

  double getPriceAfterDiscountAndQuantity(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      return (_cart[cartIndex].product.price - _cart[cartIndex].discount) * _cart[cartIndex].quantity;
    }
    return 0;
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var p in _cart) {
      total += (p.product.price - p.discount) * p.quantity;
    }
    return total;
  }

   plusOneQuantityToItem(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);

    if((_cart[cartIndex].product.remainedQuantity) <= _cart[cartIndex].quantity){
      return;
    }

    if(cartIndex != -1){
      _cart[cartIndex].quantity++;
    }
  }

  minusOneQuantityToItem(String productId) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(_cart[cartIndex].quantity <= 1){
      return;
    }
    if(cartIndex != -1){
      _cart[cartIndex].quantity--;
    }
  }

  isPriceBiggerThanDiscountPrice(double price, double discount) {
    return price > discount;
  }

  isThisProductInCart(String productId) {
    return _cart.any((p)=> p.productId == productId);
  }

  isThereAnyItemInsideCart(){
    return _cart.isNotEmpty;
  }

  // void removeItem(String item) {
  //   if (_cart.containsKey(item)) {
  //     _cart.remove(item);
  //   }
  // }
  //
  addDiscountToItem(String productId, double discount) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      _cart[cartIndex].discount = discount;
    }
  }

  deleteItemFromCart(String productId) async {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      _cart.removeAt(cartIndex);
    }
  }

  updateItemQuantity(String productId, int quantity) async {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      _cart[cartIndex].quantity = quantity;
    }
  }

  updateProductInfo(String productId, ProductModel product) async {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);
    if(cartIndex != -1){
      _cart[cartIndex].product = product;
    }
  }

  removeCart() {
   _cart.clear();
  }
  idThereProductInCart(String productId) {
    if (_cart.any((p)=> p.productId == productId)) {
      return true;
    }
    return false;
  }
}