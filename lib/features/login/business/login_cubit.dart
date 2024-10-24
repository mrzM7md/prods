import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/features/login/business/login_actions.dart';
import 'package:prods/features/login/models/login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  final LoginActions loginActions;
  LoginCubit({required this.loginActions}) : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  /// ### START PASSWORD VISIBILITY ### ///
  bool _isVisible = false;
  void changePasswordVisibility(){
    _isVisible = !_isVisible;
    emit(ChangeVisibilityPasswordState(isVisible: getPasswordVisibility()));
  }
  bool getPasswordVisibility() => _isVisible;
  /// ### END PASSWORD VISIBILITY ### ///

  void login(LoginModel loginModel) async {
    try {
      emit(LoginUserState(loginModel: loginModel, isSuccessful: false, message: "", isLoaded: false));
      await loginActions.login(loginModel: loginModel).then((value) {
        emit(LoginUserState(loginModel: loginModel, isSuccessful: true, message: "تم تسجيل الدخول بنجاح", isLoaded: true));
      }).catchError((error) {
        print(error);
        emit(LoginUserState(loginModel: loginModel, isSuccessful: false, message: "تحقق من معلوماتك او اتصالك بالانترنت", isLoaded: true));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginUserState(loginModel: loginModel, isSuccessful: false, message: 'تحقق من البريد أو كلمة السر', isLoaded: true));
        print(e.message);
      }
    } on FormatException catch (e) {
      print(e.message);
      emit(LoginUserState(loginModel: loginModel, isSuccessful: false, message: 'تنسيق البريد الإلكتروني غير صحيح', isLoaded: true));
    }
  }
}
