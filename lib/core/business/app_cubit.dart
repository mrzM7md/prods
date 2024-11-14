import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/business/app_state.dart';

import '../../features/control_panel/business/sections/app_actions.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({required this.appActions}) : super(AppStateInitial());
  final AppActions appActions;

  static AppCubit get(context) => BlocProvider.of(context);

  goToAppStateInitialState(){
    emit(AppStateInitial());
  }
  changeBetweenFromAndToTime(bool isYouInFrom){
    emit(ChangeBetweenFromAndToTime(areYouInFrom: isYouInFrom));
  }

  clickOnSaveFilterOption() async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(ClickOnSaveFilterOptionState());
  }

}