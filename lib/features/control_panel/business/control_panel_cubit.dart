import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prods/core/enums/enums.dart';
import 'package:prods/core/network/local/cache_helper.dart';
import 'package:prods/features/control_panel/business/sections/app_actions.dart';
import 'package:prods/features/control_panel/models/buy_model.dart';
import 'package:prods/features/control_panel/models/category_model.dart';
import 'package:prods/features/control_panel/models/invoice_detail_model.dart';
import 'package:prods/features/control_panel/models/product_model.dart';
part 'control_panel_state.dart';

class ControlPanelCubit extends Cubit<ControlPanelState> {
  ControlPanelCubit({required this.appActions}) : super(ControlPanelInitial());
  final AppActions appActions;

  static ControlPanelCubit get(context) => BlocProvider.of(context);

  returnToInitialState(){
    emit(ControlPanelInitial());
  }

  ControlPanelSections? _section = ControlPanelSections.CATEGORIES;
  ControlPanelSections? getControlPanelSection() => _section;
  setSection(ControlPanelSections? section) => _section = section;
  setControlPanelSections(ControlPanelSections section) async {
    // changeAppSectionVisibility();
    setSection(null);
    emit(ChangeControlPanelSectionState(section: getControlPanelSection()));
    await Future.delayed(const Duration(milliseconds: 500));
    setSection(section);
    emit(ChangeControlPanelSectionState(section: getControlPanelSection()));
  }

  bool _isVisibleSections = false;
  getIsVisibleSections() => _isVisibleSections;
  setIsVisibleSections(bool isVisible) => _isVisibleSections = isVisible;
  changeAppSectionVisibility (){
    setIsVisibleSections(!getIsVisibleSections());
    emit(ChangeAppSectionVisibilityState(isVisible: getIsVisibleSections()));
  }

  ConnectivityState _connectivityState = CacheHelper.getBool(key: CacheHelper.connectStateKey) ?? true ? ConnectivityState.ONLINE : ConnectivityState.OFFLINE;
  ConnectivityState getConnectivityState() {
    _connectivityState = getConnectivityStateFromBoll(CacheHelper.getBool(key: CacheHelper.connectStateKey) ?? true);
    return _connectivityState;
  }

  setConnectivityState(ConnectivityState state) {
    CacheHelper.setData(key: CacheHelper.connectStateKey, value:getBollFromConnectivityState(state));
    _connectivityState = state;
  }

  changeConnectivityState(ConnectivityState state) async {
    var connectivityState = getConnectivityState();
    if(connectivityState != state){
      setConnectivityState(state);
      if(state == ConnectivityState.ONLINE) {
        goOnline();
      }
      else{
        goOffline();
      }
      emit(ChangeConnectivityState(state: state));
    }
  }

  getBollFromConnectivityState(ConnectivityState state){
    return state == ConnectivityState.ONLINE ? true : false;
  }

  getConnectivityStateFromBoll(bool value){
    switch(value){
      case true:
        return ConnectivityState.ONLINE;
      case false:
        return ConnectivityState.OFFLINE;
      default:
        return ConnectivityState.ONLINE;
    }
  }

  void goOffline() async {
    await FirebaseFirestore.instance.disableNetwork();
  }
  void goOnline() async {
    await FirebaseFirestore.instance.enableNetwork();
  }


}
