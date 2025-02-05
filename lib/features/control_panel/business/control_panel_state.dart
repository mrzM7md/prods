part of 'control_panel_cubit.dart';

sealed class ControlPanelState {
  const ControlPanelState();
}

final class ControlPanelInitial extends ControlPanelState {}

final class ChangeControlPanelSectionState implements ControlPanelState {
  final ControlPanelSections? section;
  const ChangeControlPanelSectionState({required this.section});
}
final class ChangeAppSectionVisibilityState extends Equatable implements ControlPanelState {
  final bool isVisible;
  const ChangeAppSectionVisibilityState({required this.isVisible});

  @override
  List<Object?> get props => [isVisible];
}

final class ChangeConnectivityState implements ControlPanelState {
  final ConnectivityState state;
  const ChangeConnectivityState({required this.state});
}

// ### START CATEGORIES STATES ### //
final class GetAllCategoriesState extends Equatable implements ControlPanelState{
  final List<CategoryModel>? categories;
  final bool isLoaded, isSuccess;
  final String message;

  const GetAllCategoriesState({required this.categories, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [categories, isLoaded, isSuccess, message];
}

final class AddEditCategoryState /* extends Equatable */ implements ControlPanelState{
  // final CategoryModel? categoryModel;
  final bool isLoaded, isSuccess;
  final String message;

  const AddEditCategoryState({/* required this.categoryModel ,*/  required this.isLoaded, required this.isSuccess, required this.message});

  // @override
  // List<Object?> get props => [categoryModel, isLoaded, isSuccess, message];
}

final class DeleteCategoryState extends Equatable implements ControlPanelState{
  final CategoryModel categoryModel;
  final bool isLoaded, isSuccess;
  final String message;

  const DeleteCategoryState({required this.categoryModel, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [categoryModel, isLoaded, isSuccess, message];
}

final class ChangeAddNewOrEditCategoryBoxState extends Equatable implements ControlPanelState {
  final bool isClickedOnAddNewCategory;
  final CategoryModel? category;
  final int? index;
  const ChangeAddNewOrEditCategoryBoxState({required this.isClickedOnAddNewCategory, required this.category, required this.index});
  
  @override
  List<Object?> get props => [isClickedOnAddNewCategory];
}

// ### START CATEGORIES STATES ### //



// ### START PRODUCTS STATES ### //
final class GetAllProductsState implements ControlPanelState{
  final List<ProductModel>? products;
  final bool isLoaded, isSuccess;
  final String message;

  const GetAllProductsState({required this.products, required this.isLoaded, required this.isSuccess, required this.message});
}

final class AddEditProductState extends Equatable implements ControlPanelState{
  final ProductModel? productModel;
  final bool isLoaded, isSuccess;
  final String message;

  const AddEditProductState({required this.productModel, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [productModel, isLoaded, isSuccess, message];
}

final class DeleteProductState extends Equatable implements ControlPanelState{
  final ProductModel productModel;
  final bool isLoaded, isSuccess;
  final String message;

  const DeleteProductState({required this.productModel, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [productModel, isLoaded, isSuccess, message];
}

final class GetProductsByIdsState extends Equatable implements ControlPanelState{
  final List<ProductModel>? products;
  final bool isLoaded, isSuccess;
  final String message;

  const GetProductsByIdsState({required this.products, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [products, isLoaded, isSuccess, message];
}

final class GetSortProductTypeSelectedState implements ControlPanelState{
  final SortProductType type;

  const GetSortProductTypeSelectedState({required this.type});
}

final class ChangeInvoiceTypeSelectedState implements ControlPanelState{
  final InvoiceFilterType type;
  final double totalPrice;

  const ChangeInvoiceTypeSelectedState({required this.type, required this.totalPrice});
}

final class ChangeAddNewOrEditProductBoxState extends Equatable implements ControlPanelState {
  final bool isClickedOnAddNewProduct;
  final ProductModel? product;
  final int? index;
  const ChangeAddNewOrEditProductBoxState({required this.isClickedOnAddNewProduct, required this.product, required this.index});

  @override
  List<Object?> get props => [isClickedOnAddNewProduct];
}

final class GetSelectedCategoriesFiltersState implements ControlPanelState{
  final List<String> catIds;
  GetSelectedCategoriesFiltersState({required this.catIds});
}

final class GetSelectedCategoriesForProductAddingState implements ControlPanelState{
  final List<String> catIds;
  GetSelectedCategoriesForProductAddingState({required this.catIds});
}

final class GetProductDetailState implements ControlPanelState{
  final ProductModel? productModel;
  final bool isLoaded, isSuccess;
  final String message;
  GetProductDetailState({required this.productModel, required this.isLoaded, required this.isSuccess, required this.message});
}

final class ChangeFilterOptionsState implements ControlPanelState{}

// ### END PRODUCTS STATES ### //




// ### START CARTS STATES ### //
final class AddToCartState implements ControlPanelState{
  final String productId;
  final bool isSuccess;
  final String message;
  const AddToCartState({required this.productId, required this.isSuccess, required this.message});
}

final class ChangeQuantityToItemAndAddDiscountState implements ControlPanelState{
  final String productId;
  const ChangeQuantityToItemAndAddDiscountState({required this.productId});
}

final class DeleteItemFromCartState implements ControlPanelState{
  final String productId, message;
  final bool isLoaded;
  const DeleteItemFromCartState({required this.productId, required this.isLoaded, required this.message});
}

final class ChangeCartQuantityAfterComa implements ControlPanelState {
  final CartQuantityAfterComa cartQuantityAfterComa;
  final String id;

  ChangeCartQuantityAfterComa({required this.cartQuantityAfterComa, required this.id});
}
// ### END CARTS STATES ### //



// ### START INVOICES STATES ### //
final class AddInvoiceState implements ControlPanelState{
  final bool isSuccess, isLoaded;
  final String message;
  const AddInvoiceState({required this.isSuccess, required this.message, required this.isLoaded});
}

final class GetInvoiceState implements ControlPanelState{
  final bool isSuccess, isLoaded;
  final String message;

  GetInvoiceState({required this.isSuccess, required this.isLoaded, required this.message});
}

final class GetInvoiceDetailsState implements ControlPanelState {
  final String invoiceId, message;
  final List<InvoiceDetailModel> invoiceDetails;
  final bool isLoaded, isSuccess;

  const GetInvoiceDetailsState({required this.invoiceId, required this.isLoaded, required this.message, required this.invoiceDetails, required this.isSuccess});
}
// ### END INVOICES STATES ### //

// ### START BUYS STATUS ### //
final class GetAllBuysState implements ControlPanelState{
  final List<BuyModel>? buys;
  final bool isLoaded, isSuccess;
  final String message;

  const GetAllBuysState({required this.buys, required this.isLoaded, required this.isSuccess, required this.message});
}

final class AddEditBuyState extends Equatable implements ControlPanelState{
  final BuyModel? buyModel;
  final bool isLoaded, isSuccess, isForAdd;
  final String message;

  const AddEditBuyState({required this.buyModel, required this.isLoaded, required this.isSuccess, required this.message, required this.isForAdd});

  @override
  List<Object?> get props => [buyModel, isLoaded, isSuccess, message, isForAdd];
}

final class DeleteBuyState extends Equatable implements ControlPanelState{
  final BuyModel buyModel;
  final bool isLoaded, isSuccess;
  final String message;

  const DeleteBuyState({required this.buyModel, required this.isLoaded, required this.isSuccess, required this.message});

  @override
  List<Object?> get props => [buyModel, isLoaded, isSuccess, message];
}
// ### END BUYS STATUS ### //