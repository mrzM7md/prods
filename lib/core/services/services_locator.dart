import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:prods/core/business/app_cubit.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/show_components.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/app_actions.dart';
import 'package:prods/features/control_panel/business/sections/buys_actions.dart';
import 'package:prods/features/control_panel/business/sections/buys_cubit.dart';
import 'package:prods/features/control_panel/business/sections/carts_actions.dart';
import 'package:prods/features/control_panel/business/sections/carts_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_actions.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/business/sections/invoice_actions.dart';
import 'package:prods/features/control_panel/business/sections/invoice_cubit.dart';
import 'package:prods/features/control_panel/business/sections/products_actions.dart';
import 'package:prods/features/control_panel/business/sections/products_cubit.dart';
import 'package:prods/features/control_panel/features/bills/presentation/invoices_page.dart';
import 'package:prods/features/control_panel/features/buys/presentation/buys_page.dart';
import 'package:prods/features/control_panel/features/carts/presentation/cart_page.dart';
import 'package:prods/features/control_panel/features/categories/presentation/categories_page.dart';
import 'package:prods/features/control_panel/features/products/presentation/products_page.dart';
import 'package:prods/features/control_panel/features/statistics/presentation/statistics_page.dart';
import 'package:prods/features/login/business/login_actions.dart';
import 'package:prods/features/login/business/login_cubit.dart';
import 'package:uuid/uuid.dart';

import '../consts/widgets_components.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {

    /// ####################### Start Control Panel - Injection #######################  ///
    sl.registerLazySingleton(() => AppActions());
    /// ####################### End Control Panel - Injection #######################  ///

    /// ####################### Start Auth - Injection #######################  ///
    sl.registerLazySingleton(() => LoginActions());
    sl.registerLazySingleton(() => LoginCubit(
      loginActions: sl<LoginActions>(),
    ));
    /// ####################### End Auth - Injection #######################  ///
    sl.registerLazySingleton(() => ControlPanelCubit(
      appActions: sl<AppActions>(),
    ));
    sl.registerLazySingleton(() => CategoriesActions());
    sl.registerLazySingleton(() => ProductsActions(categoriesActions: sl<CategoriesActions>()));
    sl.registerLazySingleton(() => CartsActions());
    sl.registerLazySingleton(() => InvoiceActions(cartsActions: sl<CartsActions>(), productsActions: sl<ProductsActions>()));
    sl.registerLazySingleton(() => BuysActions());

    sl.registerLazySingleton(() => CategoriesCubit(categoriesActions: sl<CategoriesActions>(), appActions: sl<AppActions>()));
    sl.registerLazySingleton(() => ProductsCubit(productsActions: sl<ProductsActions>(), categoriesActions: sl<CategoriesActions>(), appActions: sl<AppActions>()));
    sl.registerLazySingleton(() => CartsCubit(cartActions: sl<CartsActions>(), productsActions: sl<ProductsActions>(), appActions: sl<AppActions>()));
    sl.registerLazySingleton(() => InvoiceCubit(invoiceActions: sl<InvoiceActions>(), appActions: sl<AppActions>()));
    sl.registerLazySingleton(() => BuysCubit(buysActions: sl<BuysActions>(), appActions: sl<AppActions>()));
    sl.registerLazySingleton(() => AppCubit(appActions: sl<AppActions>()));

    sl.registerLazySingleton(() => const CategoriesPage());
    sl.registerLazySingleton(() => const ProductsPage());
    sl.registerLazySingleton(() => const InvoicesPage());
    sl.registerLazySingleton(() => const StatisticsPage());
    sl.registerLazySingleton(() => const CartPage());
    sl.registerLazySingleton(() => const BuysPage());
    sl.registerLazySingleton(() => const CircularProgressIndicator(color: AppColors.appGrey,));

    /// UUID
    sl.registerLazySingleton(() => const Uuid());
    sl.registerLazySingleton(() => AppDialogs());
    sl.registerLazySingleton(() => ShowCustomMessage());
  }
}