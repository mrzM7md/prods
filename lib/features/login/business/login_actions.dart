import 'package:firebase_auth/firebase_auth.dart';
import 'package:prods/features/login/models/login_model.dart';

class LoginActions {
  Future<void> login({required LoginModel loginModel}) async =>
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginModel.email,
        password: loginModel.password,
      );
}
