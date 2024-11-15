import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/consts/app_colors.dart';
import 'package:prods/core/consts/app_images.dart';
import 'package:prods/core/consts/app_routes.dart';
import 'package:prods/core/consts/style_components.dart';
import 'package:prods/core/consts/widgets_components.dart';
import 'package:prods/features/login/business/login_cubit.dart';
import 'package:prods/features/login/models/login_model.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext pageContext) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    LoginCubit cubit = LoginCubit.get(pageContext);
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.appBackground,
          body: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppImages.appLogo,
                          height: 102,
                          width: 102,
                        ),
                        Text(
                          "نظام البسيط",
                          style: getGlobalTextStyle().copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Amiri"),
                        ),
                        const SizedBox(
                          height: 34,
                        ),
                        Text(
                          "تسجيل الدخول",
                          style: getGlobalTextStyle().copyWith(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 77,
                        ),
                        Form(
                            key: formKey,
                            child: Column(
                              children: [
                                getAppTextField(
                                    text: "البريد الإلكتروني",
                                    onChange: (value) {},
                                    controller: emailController,
                                    fillColor: AppColors.appLightGreenColor,
                                    obscureText: false,
                                    direction: TextDirection.ltr,
                                    suffixIconButton: null,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "البريد الإلكتروني مطلوب";
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                                BlocBuilder<LoginCubit, LoginState>(
                                  buildWhen: (previous, current) =>
                                      current is ChangeVisibilityPasswordState,
                                  builder: (context, state) {
                                    return getAppTextField(
                                        text: "كلمة السر",
                                        onChange: (value) {},
                                        controller: passwordController,
                                        fillColor: AppColors.appLightGreenColor,
                                        obscureText:
                                            !cubit.getPasswordVisibility(),
                                        suffixIconButton: IconButton(
                                            onPressed: () {
                                              cubit.changePasswordVisibility();
                                            },
                                            icon: ConditionalBuilder(
                                              condition:
                                                  cubit.getPasswordVisibility(),
                                              builder: (context) => const Icon(
                                                  Icons.visibility_outlined),
                                              fallback: (context) => const Icon(
                                                  Icons.visibility_off_outlined),
                                            )),
                                        direction: TextDirection.ltr,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "كلمة السر مطلوبة";
                                          }
                                          return null;
                                        });
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            )),
                        BlocConsumer<LoginCubit, LoginState>(
                          buildWhen: (previous, current) => current is LoginUserState,
                          listenWhen: (previous, current) => current is LoginUserState && current.isLoaded,
                          listener: (context, state) {
                            if(state is LoginUserState){
                              if(!state.isSuccessful) {
                                showCustomToast(message: state.message, bkgColor: AppColors.appRedColor, textColor: Colors.black, context: pageContext);
                              }
                              else{
                                showCustomToast(message: state.message, bkgColor: AppColors.appLightGreenColor, textColor: Colors.black, context: pageContext);
                                pageContext.goNamed(AppRoutes.controlPanelRouter);
                              }
                            }
                          },
                          builder: (context, state) {
                            if(state is LoginUserState){
                              if(!state.isLoaded){
                                return const CircularProgressIndicator(color: AppColors.appGreenColor,);
                              }
                            }
                            return getAppButton(
                                color: AppColors.appGreenColor,
                                textColor: Colors.white,
                                text: "تسجيل الدخول",
                                onClick: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.login(LoginModel(
                                        email: emailController.text,
                                        password: passwordController.text));
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    // const SnackBar(
                                    //   backgroundColor: Colors.red,
                                    //     closeIconColor: Colors.red,
                                    //     content: Row(
                                    //       children: [
                                    //         CircularProgressIndicator(),
                                    //         Spacer(),
                                    //         Text("data")
                                    //       ],
                                    //     )),
                                    // );
                                  }
                                });
                          },
                        )
                      ],
                    )),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
