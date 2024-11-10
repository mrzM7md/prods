import 'package:prods/features/control_panel/models/product_model.dart';

class CartModel{
  final String productId;
  double quantity;
  double discount;
  ProductModel product;
  CartModel(this.productId, this.quantity, this.discount, this.product);
}