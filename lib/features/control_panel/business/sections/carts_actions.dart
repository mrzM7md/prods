import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/models/cart_model.dart';
import 'package:prods/features/control_panel/models/product_model.dart';

class CartsActions {
  final List<CartModel> _cart = [];
  final List<String> _cartProductsIdsHasOneQuantity = [];
  List<CartModel> getCart() {

    _cartProductsIdsHasOneQuantity.clear();
    _cartProductsIdsHasOneQuantity.addAll(
      _cart.where((c) => c.quantity == 0).map((cart) => cart.productId).toList()
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

  double getQuantity(String productId) {
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

  changeQuantityToItem(String productId, double newQuantity) {
    int cartIndex = _cart.indexWhere(
            (p) => p.productId == productId);

    if((_cart[cartIndex].product.remainedQuantity) <= _cart[cartIndex].quantity){
      return;
    }

    if(cartIndex != -1){
      _cart[cartIndex].quantity = newQuantity;
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

  final Map<CartQuantityAfterComa, double> _decimalWithCartQuantityAfterComa = <CartQuantityAfterComa, double>{
    CartQuantityAfterComa.NO_THING : 0,
    CartQuantityAfterComa.AND_1_ON_10 : 0.1,
    CartQuantityAfterComa.AND_1_ON_9 : 0.9,
    CartQuantityAfterComa.AND_1_ON_8 : 0.125,
    CartQuantityAfterComa.AND_1_ON_7 : 0.1429,
    CartQuantityAfterComa.AND_1_ON_6 : 0.1667,
    CartQuantityAfterComa.AND_1_ON_5 : 0.2,
    CartQuantityAfterComa.AND_1_ON_4 : 0.25,
    CartQuantityAfterComa.AND_1_ON_3 : 0.3333,
    CartQuantityAfterComa.AND_1_ON_2 : 0.5,
    CartQuantityAfterComa.AND_3_ON_4 : 0.75,
  };

  final Map<double, String> _afterComaToName = <double, String>{
    0:"",
    0.1: "عشر",
    0.9: "تسع",
    0.125: "ثمن",
    0.1429: "سبع",
    0.1667: "سدس",
    0.2: "خمس",
    0.25: "ريع",
    0.3333: "ثلث",
    0.5: "نص",
    0.75: "ثلاثة أرباع (إلا ربع)",
  };

  Map<double, String> getAfterComaToName() => _afterComaToName;

  Map<CartQuantityAfterComa, double> getDecimalWithCartQuantityAfterComa() => _decimalWithCartQuantityAfterComa;

  CartQuantityAfterComa convertDecimalToCartQuantityAfterComa(double number) {
    int wholePart = number.floor();
    double decimalPart = number - wholePart;

    // تقريب الجزء العشري إلى 4 أرقام عشرية
    decimalPart = double.parse(decimalPart.toStringAsFixed(4));

    CartQuantityAfterComa key = CartQuantityAfterComa.NO_THING;
    for (var entry in _decimalWithCartQuantityAfterComa.entries) {
      if (decimalPart == entry.value) {
        key = entry.key;
        break;
      }
    }

    return key;
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

  updateItemQuantity(String productId, double quantity) async {
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