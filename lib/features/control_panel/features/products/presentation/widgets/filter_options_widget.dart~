import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/business/sections/products_cubit.dart';
import 'package:prods/features/control_panel/features/products/presentation/widgets/filter_option_button_Item_widget.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

class FilterCategoriesOptionsWidget extends StatelessWidget {
  const FilterCategoriesOptionsWidget({super.key, required this.scrollCategoryController, required this.searchText});
  final ScrollController scrollCategoryController;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    CategoriesCubit categoriesCubit = CategoriesCubit.get(context);
    ProductsCubit productsCubit = ProductsCubit.get(context);
    categoriesCubit.getAllCategories();
    return BlocBuilder<CategoriesCubit, ControlPanelState>(
      buildWhen: (previous, current) => current is GetAllCategoriesState,
      builder: (context, state) {
        if(state is GetAllCategoriesState){
          if(! state.isLoaded){
            return const SizedBox(
              height: 20,
              child: CircularProgressIndicator(),
            );
          }
          if(state.isSuccess){
            List<CategoryModel> data = state.categories!;
            if(data.isEmpty){
              return Container();
            }
            return Scrollbar(
              interactive: true,
              trackVisibility: true,
              controller: scrollCategoryController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollCategoryController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: BlocBuilder<ProductsCubit, ControlPanelState>(
                        buildWhen: (previous, current) => current is GetSelectedCategoriesFiltersState,
                      builder: (context, state) {
                          var bgColor = Colors.black54;
                          if(productsCubit.productsActions.getSelectedCategoriesFilter().isEmpty){
                            bgColor = AppColors.appGreenColor;
                          }
                        return FilterOptionButtonItemWidget(text: "الكل", color: Colors.white, bgColor:bgColor,  onClick: (){
                          if(productsCubit.productsActions.getSelectedCategoriesFilter().isNotEmpty){
                            productsCubit.clearAllCategoriesSelected(searchText);
                          }
                      });
                          },),
                    ),
                    const SizedBox(width: 5,),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(width: 5,),
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: BlocBuilder<ProductsCubit, ControlPanelState>(
                            buildWhen: (previous, current) => current is GetSelectedCategoriesFiltersState,
                          builder: (context, state) {
                              var bgColor = Colors.black54;
                              if(state is GetSelectedCategoriesFiltersState && state.catIds.contains(data[index].id) ){
                                bgColor = AppColors.appGreenColor;
                              }
                              if(state is ! GetSelectedCategoriesFiltersState){
                                if(productsCubit.productsActions.getSelectedCategoriesFilter().contains(data[index].id)){
                                  bgColor = AppColors.appGreenColor;
                                }
                              }
                            return FilterOptionButtonItemWidget(
                            text: data[index].name, color: Colors.white, bgColor: bgColor,
                            onClick: () {
                              productsCubit.selectNewCategoryOrUnSelect(data[index].id, searchText);
                            },);
  },
),
                        );
                      },),
                  ],
                ),
              ),
            );
          }
        }
        return const SizedBox(
          width: 20,
          child: CircularProgressIndicator(),
        );
      },
    );}}
