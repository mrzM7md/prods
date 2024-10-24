import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/features/bills/presentation/invoices_page.dart';
import 'package:prods/features/control_panel/features/carts/presentation/cart_page.dart';
import 'package:prods/features/control_panel/features/categories/presentation/categories_page.dart';
import 'package:prods/features/control_panel/presentation/widgets/control_panel_sections_widget.dart';
import 'package:prods/features/control_panel/features/products/presentation/products_page.dart';
import 'package:prods/features/control_panel/features/statistics/presentation/statistics_page.dart';

import '../../../core/services/services_locator.dart';

class ControlPanelPage extends StatelessWidget {
  const ControlPanelPage({super.key});

  @override
  Widget build(BuildContext context) {
    ControlPanelCubit cubit = ControlPanelCubit.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        body: Stack(
          children: [
            Row(
              children: [
                ConditionalBuilder(
                  condition: MediaQuery.sizeOf(context).width > ScreensSizes.smallScreen,
                  builder: (context) => const SizedBox(
                    width: 220,
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: ControlPanelSectionsWidget(),
                      ),
                    ),
                  ),
                  fallback: (context) => Container(),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsetsDirectional.only(
                      top: 20,
                      end: 20,
                      bottom: 20,
                      start: MediaQuery.sizeOf(context).width <= ScreensSizes.smallScreen ? 20 : 0),
                  child: Column(
                    children: [
                      ConditionalBuilder(
                        condition: MediaQuery.sizeOf(context).width <= ScreensSizes.smallScreen,
                        builder: (context) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  bottom: 10, start: 20),
                              child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: IconButton(
                                      onPressed: () {
                                        cubit.changeAppSectionVisibility();
                                      },
                                      icon: const Icon(Icons.menu))),
                            ),
                          ],
                        ),
                        fallback: (context) => Container(),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.appGrey,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                // لون الظل
                                spreadRadius: 5,
                                // مدى انتشار الظل
                                blurRadius: 7,
                                // درجة تشتت الظل
                                offset: const Offset(
                                    5, 5), // اتجاه الظل (للأسفل واليمين)
                              ),
                            ],
                          ),
                          child:
                              BlocBuilder<ControlPanelCubit, ControlPanelState>(
                            buildWhen: (previous, current) =>
                                current is ChangeControlPanelSectionState,
                            builder: (context, state) {
                              switch (cubit.getControlPanelSection()) {
                                case null:
                                  {
                                    return getAppProgress();
                                  }
                                case ControlPanelSections.CATEGORIES:
                                  return sl<CategoriesPage>();
                                case ControlPanelSections.PRODUCTS:
                                  return sl<ProductsPage>();
                                case ControlPanelSections.BILLS:
                                  return sl<InvoicesPage>();
                                case ControlPanelSections.CART:
                                  return sl<CartPage>();
                                default:
                                  return sl<StatisticsPage>();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
            BlocBuilder<ControlPanelCubit, ControlPanelState>(
              buildWhen: (previous, current) =>
              current is ChangeAppSectionVisibilityState,
              builder: (context, state) {
                if (state is ChangeAppSectionVisibilityState &&
                    state.isVisible) {

                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.white,
                        child: ControlPanelSectionsWidget()
                    ),
                  );
                }

                return Container();
              },
            ),
          ],
        ),
      )),
    );
  }
}
