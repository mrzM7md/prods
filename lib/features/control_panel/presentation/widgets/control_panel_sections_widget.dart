import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/app_images.dart';
import 'package:prods/core/consts/app_routes.dart';
import 'package:prods/core/consts/sscreens_size.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/features/control_panel/business/control_panel_cubit.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

// For Flutter applications, you'll most likely want to use
// the url_launcher package.
import 'drawer_list_tile_widget.dart';

class ControlPanelSectionsWidget extends StatelessWidget {
  const ControlPanelSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ControlPanelCubit cubit = ControlPanelCubit.get(context);
    if(cubit.getConnectivityState() == ConnectivityState.ONLINE) {
      cubit.goOnline();
    }
    else{
      cubit.goOffline();
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConditionalBuilder(
              condition: MediaQuery.sizeOf(context).width <= ScreensSizes.smallScreen,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(onPressed: (){
                  cubit.changeAppSectionVisibility();
                }, icon: const Icon(Icons.close)),
              ), fallback: (context) => Container(),) ,
          Image.asset(
            AppImages.logo,
            height: 90,
            width: 90,
          ),
          const Text(
            "متجر ثقة",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BlocBuilder<ControlPanelCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is ChangeConnectivityState,
                builder: (context, state) {
                  Color color = Colors.black54;
                  if(cubit.getConnectivityState() == ConnectivityState.ONLINE) {
                    color = AppColors.appGreenColor;
                  }
                  return IconButton(onPressed: (){
                    cubit.changeConnectivityState(ConnectivityState.ONLINE);
              }, icon: const Icon(Icons.wifi), color: color, hoverColor: AppColors.appLightGreenColor);
        },
      ),
              BlocBuilder<ControlPanelCubit, ControlPanelState>(
                buildWhen: (previous, current) => current is ChangeConnectivityState,
                builder: (context, state) {
                  Color color = Colors.black54;
                  if(cubit.getConnectivityState() == ConnectivityState.OFFLINE) {
                    color = AppColors.appGreenColor;
                  }
                  return IconButton(onPressed: (){
                    cubit.changeConnectivityState(ConnectivityState.OFFLINE);
                    }, icon: const Icon(Icons.wifi_off), color: color, hoverColor: AppColors.appLightGreenColor);
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<ControlPanelCubit, ControlPanelState>(
            buildWhen: (previous, current) =>
            current is ChangeControlPanelSectionState,
            builder: (context, state) {
              return DrawerListTileWidget(
                title: "الأصناف",
                icon: AppImages.categories,
                press: () {
                  cubit.setControlPanelSections(
                      ControlPanelSections.CATEGORIES);
                  hiddenSectionsBoardOnSmallScreens(context, cubit);
                },
                bgColor: cubit.getControlPanelSection() ==
                    ControlPanelSections.CATEGORIES
                    ? AppColors.appLightBlueColor
                    : null,
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          BlocBuilder<ControlPanelCubit, ControlPanelState>(
            buildWhen: (previous, current) =>
            current is ChangeControlPanelSectionState,
            builder: (context, state) {
              return DrawerListTileWidget(
                title: "المنتجات",
                icon: AppImages.products,
                press: () {
                  cubit.setControlPanelSections(ControlPanelSections.PRODUCTS);
                  hiddenSectionsBoardOnSmallScreens(context, cubit);
                },
                bgColor: cubit.getControlPanelSection() ==
                    ControlPanelSections.PRODUCTS
                    ? AppColors.appLightBlueColor
                    : null,
              );
            },
          ),
          const SizedBox(height: 5,),
          BlocBuilder<ControlPanelCubit, ControlPanelState>(
            buildWhen: (previous, current) =>
            current is ChangeControlPanelSectionState,
            builder: (context, state) {
              return DrawerListTileWidget(
                title: "السلة",
                icon: AppImages.addToCart,
                press: () {
                  cubit.setControlPanelSections(ControlPanelSections.CART);
                  hiddenSectionsBoardOnSmallScreens(context, cubit);
                },
                bgColor: cubit.getControlPanelSection() ==
                    ControlPanelSections.CART
                    ? AppColors.appLightBlueColor
                    : null,
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          BlocBuilder<ControlPanelCubit, ControlPanelState>(
            buildWhen: (previous, current) =>
            current is ChangeControlPanelSectionState,
            builder: (context, state) {
              return DrawerListTileWidget(
                title: "الفواتير",
                icon: AppImages.bills,
                press: () {
                  cubit.setControlPanelSections(
                      ControlPanelSections.BILLS);
                  hiddenSectionsBoardOnSmallScreens(context, cubit);
                },
                bgColor: cubit.getControlPanelSection() ==
                    ControlPanelSections.BILLS
                    ? AppColors.appLightBlueColor
                    : null,
              );
            },
          ),
          const SizedBox(
            height: 5,
          ),
          DrawerListTileWidget(
            title: "الدعم الفني 774520862",
            icon: AppImages.support,
            color: AppColors.appGreenColor,
            press: openWhatsApp,
            bgColor: null,
          ),
          const SizedBox(
            height: 70,
          ),
          DrawerListTileWidget(
            title: "تسجيل الخروج",
            icon: AppImages.logout,
            color: AppColors.appRedColor,
            press: () async {
              FirebaseAuth.instance.signOut();
              context.goNamed(AppRoutes.loginRouter);
            },
            bgColor: null,
          )
        ],
      ),
    );
  }

  void hiddenSectionsBoardOnSmallScreens(BuildContext context, ControlPanelCubit cubit) {
    if(MediaQuery.sizeOf(context).width <= ScreensSizes.smallScreen){
      cubit.changeAppSectionVisibility();
    }
  }


  void openWhatsApp() async {
    String phoneNumber = "9670774520862"; // استبدل برقم الهاتف
    String message = "أحتاج إلى مساعدة!"; // استبدل بالنص الذي تريد إرساله
    String url = "whatsapp://send?phone=$phoneNumber&text=$message";

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
