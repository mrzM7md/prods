import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String email;
  final String password;

  const LoginModel({required this.email, required this.password});

  factory LoginModel.fromSnapshot({required Map<String, dynamic> snapshot}) {
    return LoginModel(email: snapshot["email"], password: snapshot["password"]);
  }

  Map<String, dynamic> toDocument()=> {
      "email": email,
      "password": password,
    };


  @override
  List<Object?> get props => [email, password];

}