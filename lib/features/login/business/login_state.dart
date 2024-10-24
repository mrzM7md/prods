part of 'login_cubit.dart';

sealed class LoginState extends Equatable {}

final class LoginInitialState extends LoginState {
  @override
  List<Object> get props => [];
}

final class ChangeVisibilityPasswordState extends LoginState{
  final bool isVisible;
  ChangeVisibilityPasswordState({required this.isVisible});
  @override
  List<Object> get props => [isVisible];
}

final class LoginUserState extends LoginState {
  final String message;
  final LoginModel loginModel;
  final bool isSuccessful;
  final bool isLoaded;
  LoginUserState({required this.loginModel, required this.isSuccessful, required this.message, required this.isLoaded});

  @override
  List<Object> get props => [loginModel, isSuccessful, message, isLoaded];
}


