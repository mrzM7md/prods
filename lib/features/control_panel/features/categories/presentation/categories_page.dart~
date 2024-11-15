import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/app_images.dart';
import 'package:prods/core/consts/helpers_methods.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:prods/features/control_panel/business/sections/categories_cubit.dart';
import 'package:prods/features/control_panel/features/categories/presentation/widgets/add_edit_category_widget.dart';
import 'package:prods/features/control_panel/models/category_model.dart';

import '../../../../../core/consts/widgets_components.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {

  late CategoriesCubit _cubit;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _controller;
  late final ScrollController _scrollInfoHorizontalController;

  @override
  void initState() {
    _cubit = CategoriesCubit.get(context);
    _formKey = GlobalKey<FormState>();
    _controller = _controller = TextEditingController();
    _scrollInfoHorizontalController = ScrollController();

    _cubit.getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext pageContext) {

  return SizedBox(
      width: double.infinity,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          AddEditCategoryWidget(context: pageContext, controller: _controller, formKey: _formKey, message: "", bkgColor: Colors.white, textColor: Colors.black),
            BlocBuilder<CategoriesCubit, ControlPanelState>(
              buildWhen: (previous, current) => current is ChangeAddNewOrEditCategoryBoxState, builder: (context, state) {
              if(!(state is ! ChangeAddNewOrEditCategoryBoxState || ! state.isClickedOnAddNewCategory)) {
                return Container();
              }
                return Padding(padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConditionalBuilder(condition: MediaQuery.sizeOf(context).width <= ScreensSizes.smallScreen,
                        builder: (context) => const Column(
                          children: [
                            Text("الأصناف", style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                          ],
                        ), fallback: (context) => Container(),),
                      getAppButton(icon: Icons.add,
                          color: Colors.white,
                          textColor: Colors.black,
                          text: MediaQuery.sizeOf(context).width > ScreensSizes.smallScreen ? "إضافة صنف جديد" : "",
                          onClick: () {
                            _cubit.changeClickedOnAddNewOrEditCategory();
                          }),
                    ],
                  ),
                ],
              ),
            );
    },
  ),
            const SizedBox(height: 22,),
            Expanded(
              child: BlocBuilder<CategoriesCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is GetAllCategoriesState,
                builder: (context, state) {
                  if (state is GetAllCategoriesState) {
                    if (!state.isLoaded) {
                      return getAppProgress();
                    }
                    if (!state.isSuccess) {
                      return getAppButton(color: Colors.white,
                          textColor: Colors.redAccent,
                          icon: Icons.refresh,
                          text: state.message, onClick: () {
                            _cubit.getAllCategories();
                          });
                    }

                    List<CategoryModel>? data = state.categories;
                    if(data == null || data.isEmpty){
                      return const Text("فارغ");
                    }

                    return Scrollbar(
                      interactive: true,
                      trackVisibility: true,
                      controller: _scrollInfoHorizontalController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollInfoHorizontalController,
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DataTable(
                              // headingRowColor: WidgetStatePropertyAll(Colors.red),
                              dividerThickness: 0,
                              columnSpacing: 100,
                              dataRowColor: WidgetStateProperty.all(
                                  Colors.white),
                              columns: <DataColumn>[
                                getAppDataColumn('خيارات'),
                                getAppDataColumn('اسم الصنف'),
                                getAppDataColumn('عدد المنتجات التابعة له'),
                                getAppDataColumn('تاريخ الإنشاء'),
                                getAppDataColumn('تاريخ التعديل'),
                              ],
                              rows: List<DataRow>.generate(data.length,
                                    (index) => DataRow(
                                      color: index % 2 == 1 ? const WidgetStatePropertyAll(AppColors.appGrey) : const WidgetStatePropertyAll(Colors.white) ,
                                      // color: WidgetStatePropertyAll(Colors.red),
                                      cells: <DataCell>[
                                        DataCell(
                                          Row(
                                          children: [
                                            MaterialButton(elevation: 0,
                                              color: AppColors.appGreenColor,
                                              onPressed: () {
                                                _cubit.changeClickedOnAddNewOrEditCategory(category: data[index], index: index);
                                              },
                                              child: Image.asset(AppImages.edit),),
                                            const SizedBox(width: 10,),
                                            BlocConsumer<CategoriesCubit, ControlPanelState>(
                                              buildWhen: (previous, current) => current is DeleteCategoryState && current.categoryModel.id == data[index].id,
                                              listenWhen: (previous, current) => current is DeleteCategoryState && current.categoryModel.id == data[index].id,
                                              listener: (context, state) {
                                                if(state is DeleteCategoryState && state.isLoaded){
                                                  if(state.isSuccess){
                                                    showCustomToast(context: context, message: state.message, bkgColor: AppColors.appGreenColor, textColor: Colors.black);
                                                  }
                                                  else{
                                                    showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black);
                                                  }
                                                }
                                              },
                                              builder: (context, state) {
                                                if(state is DeleteCategoryState && ! state.isLoaded){
                                                  return Container(
                                                    padding: const EdgeInsetsDirectional.only(start: 15),
                                                    child: getAppProgress(),
                                                  );
                                                }
                                                return
                                                  MaterialButton(elevation: 0,
                                                    color: AppColors.appRedColor,
                                                    onPressed: () {
                                                      showDeleteConfirmationMessage(context, Colors.white, "حذف '${data[index].name}'", "هل أنت متأكد، لن تتمكن من استرجاعه بمجرد الحذف", (){
                                                        _cubit.deleteCategory(index, data[index]);
                                                      });
                                                    },
                                                    child: Image.asset(AppImages.delete),);
                                              },

                                            ),
                                          ],
                                        ),),
                                        getAppDataCell(data[index].name),
                                        DataCell(Align(
                                            alignment: Alignment.center,
                                            child: FutureBuilder(
                                                future: _cubit.categoriesActions.countOfProductToSpecificCategory(data[index].id),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator());;
                                                  } else if (snapshot.hasData) {
                                                  return Text(formatNumber(snapshot.data));
                                                  }
                                                  return const Text("حدث خطأ ما");
                                                  },                                              )
                                                  ),),
                                        getAppDataCell(getFormatedDate(data[index].createdAt.toDate())),
                                        getAppDataCell(getFormatedDate(data[index].updatedAt.toDate())),
                                      ],
                                    ),
                              ),
                            ),)),
                    );
                  }
                  return getAppProgress();
                },),)
          ]));
  }

  void getAddCategoryWidget({
    required BuildContext context,
    required String message,
    required Color bkgColor,
    required Color textColor,
    required TextEditingController controller,
    required GlobalKey<FormState> formKey,
  }) {
    OverlayEntry? overlayEntry;
    CategoriesCubit cubit = CategoriesCubit.get(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: bkgColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  overlayEntry?.remove();
                },
                icon: const Icon(Icons.close),
              ),
              const SizedBox(height: 10,),
              const Text("إضافة صنف جديد", style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold,),),
              Form(
                key: formKey,
                child: getAppTextField(
                  text: "اسم الصنف",
                  onChange: (value) {},
                  validator: (value) {
                    if(value.toString().isEmpty || value == null){
                      return "يجب إدخال قيمة";
                    }
                    return null;
                  },
                  controller: controller,
                  fillColor: AppColors.appGrey,
                  obscureText: false,
                  suffixIconButton: null,
                  direction: null,
                ),
              ),
              const SizedBox(height: 20,),
              BlocConsumer<CategoriesCubit, ControlPanelState>(
                listenWhen: (previous, current) => current is AddEditCategoryState && current.isLoaded && !current.isSuccess,
                buildWhen: (previous, current) => current is AddEditCategoryState,
                builder: (context, state) {
                  if (state is AddEditCategoryState && !state.isLoaded) {
                    return getAppProgress();
                  }
                  return getAppButton(
                      color: AppColors.appGreenColor,
                      textColor: Colors.black,
                      text: "إضافة",
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          cubit.addNewCategory(controller.text);
                        }
                      });
                }, listener: (BuildContext context, ControlPanelState state) {
                if(state is AddEditCategoryState) {
                  showCustomToast(context: context, message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black,);
                }
              },
              )
            ],
          ),
        ),
      ),
            ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}
