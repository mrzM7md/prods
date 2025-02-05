import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prods/features/control_panel/business/sections/buys_actions.dart';
import 'package:prods/features/control_panel/models/buy_model.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/services_locator.dart';
import '../control_panel_cubit.dart';

class BuysCubit extends ControlPanelCubit {
  final BuysActions buysActions;

  BuysCubit({required this.buysActions, required super.appActions});

  static BuysCubit get(context) => BlocProvider.of(context);

  void getAllBuys({Timestamp? from, Timestamp? to}) async {
    emit(const GetAllBuysState(buys: null, isLoaded: false, message: "", isSuccess: true));
    try{
      List<BuyModel> buys;
      if(from == null || to == null){
        buys = await buysActions.getAllBuys();
      }
      else {
        buys = await buysActions.getAllBuysBetweenFromAndTo(from, to);
      }

      buysActions.setBuys(
          buys
      );
      emit(GetAllBuysState(buys: buys, isLoaded: true, message: "تم جلب جميع المشتريات", isSuccess: true));
    }
    catch(ex){
      print("مشكلة في جلب المشتريات: $ex");
      emit(const GetAllBuysState(buys: null, isLoaded: true, message: "حدث خطأ ما", isSuccess: false));
    }
  }

  setNewItemIntoBuys(BuyModel buy) {
    buysActions.addItemToBuys(buy);
    emit(GetAllBuysState(buys: buysActions.getBuys(), isLoaded: true, message: "ام جلب عمليات الشراء نجاح", isSuccess: true));
  }

  addNewBuy(BuyModel newBuy) async {
    emit(const AddEditBuyState(buyModel: null, isLoaded: false, isSuccess: false, message: "", isForAdd: true));
    String id = "${sl<Uuid>().v4()}-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}";
    try{
      BuyModel buyModel = BuyModel(id: id, name: newBuy.name, unit: newBuy.unit, quantity: newBuy.quantity, priceOfBuy: newBuy.priceOfBuy, priceOfSell: newBuy.priceOfSell, createdAt: newBuy.createdAt, updatedAt: newBuy.updatedAt);
      buysActions.addNewBuy(buyModel);
      emit(AddEditBuyState(buyModel: buyModel, isLoaded: true, isSuccess: true, message: "تم إضافة منتج جديد بنجاح", isForAdd: true));
      setNewItemIntoBuys(buyModel);
    }catch(ex){
      print("حدث خطأ ما عند إضافة عملية شراء: $ex");
      emit(const AddEditBuyState(buyModel: null, isLoaded: true, isSuccess: true, message: "حدث خطأ ما", isForAdd: true));
    }
  }

  editNewItemIntoBuys(BuyModel buy) {
    buysActions.editItemInBuyById(buy.id, buy);
    emit(GetAllBuysState(buys: buysActions.getBuys(), isLoaded: true, message: "ام جلب عمليات الشراء نجاح", isSuccess: true));
  }

  editBuy(BuyModel editedBuy) async {
    emit(const AddEditBuyState(buyModel: null, isLoaded: false, isSuccess: false, message: "", isForAdd: false));
    try{
      buysActions.editBuy(editedBuy);
      emit(AddEditBuyState(buyModel: editedBuy, isLoaded: true, isSuccess: true, message: "تم التعديل بنجاح", isForAdd: false));
      editNewItemIntoBuys(editedBuy);
    }catch(ex){
    print("حدث خطأ ما عند تعديل عملية شراء: $ex");
    emit(const AddEditBuyState(buyModel: null, isLoaded: true, isSuccess: false, message: "حدث خطأ ما", isForAdd: false));
    }
  }

  removeItemByIndexFromBuys(int index){
    buysActions.removeItemByIndexFromBuys(index);
    emit(GetAllBuysState(buys: buysActions.getBuys(), isLoaded: true, message: "تم جلب عمليات الشراء نجاح", isSuccess: true));
  }

  deleteBuy(int index, BuyModel buy) async {
    emit(DeleteBuyState(buyModel: buy, isLoaded: false, isSuccess: false, message: ""));
    try{
      buysActions.deleteBuy(buy);
      emit(DeleteBuyState(buyModel: buy, isLoaded: true, isSuccess: true, message: "تم الحذف بنجاح"));
      await Future.delayed(const Duration(seconds: 1));
      removeItemByIndexFromBuys(index);
    }catch(ex){
      emit(DeleteBuyState(buyModel: buy, isLoaded: true, isSuccess: false, message: "حدث خطأ ما"));
    }
  }
}