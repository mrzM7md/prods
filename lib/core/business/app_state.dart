sealed class AppState {
  const AppState();
}

final class AppStateInitial extends AppState {}

final class ChangeBetweenFromAndToTime implements AppStateInitial{
  bool areYouInFrom;
  ChangeBetweenFromAndToTime({required this.areYouInFrom});
}

final class ClickOnSaveFilterOptionState implements AppStateInitial{}



