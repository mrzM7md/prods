import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prods/features/control_panel/models/buy_model.dart';

class BuysActions {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  final List<BuyModel> _buys = [];

  Future<List<BuyModel>> getAllBuys() async {
    QuerySnapshot snapshot = await (await getBuysReference()).orderBy('createdAt', descending: true)
        .get();
    List<BuyModel> buys = [];
    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      buys.add(BuyModel.fromDocument(myDoc));
    }
    return buys;
  }

  Future<List<BuyModel>> getAllBuysBetweenFromAndTo(Timestamp from, Timestamp to) async {
    // إضافة يوم واحد إلى التاريخ النهائي
    Timestamp adjustedTo = Timestamp.fromDate(to.toDate().add(const Duration(days: 1)));

    QuerySnapshot snapshot = await (await getBuysReference())
        .where('createdAt', isGreaterThanOrEqualTo: from)
        .where('createdAt', isLessThanOrEqualTo: adjustedTo)
        .orderBy('createdAt', descending: true)
        .get();

    List<BuyModel> buys = [];
    for (var doc in snapshot.docs) {
      var myDoc = (doc.data() as Map<String, dynamic>);
      myDoc['id'] = doc.id;
      buys.add(BuyModel.fromDocument(myDoc));
    }
    return buys;
  }


  Future<BuyModel> addNewBuy(BuyModel newBuy) async {
    CollectionReference snapshot = await getBuysReference();

    await snapshot.doc(newBuy.id).set(
        newBuy.toDocument()
    );

    return newBuy;
    // snapshot
  }

  Future<BuyModel> editBuy(BuyModel buyModel) async {
    CollectionReference snapshot = await getBuysReference();

    await snapshot.doc(buyModel.id).update(
        buyModel.toDocument()
    );

    return buyModel;
    // snapshot
  }


  //#### START BUYS ACTION METHODS ###//
  Future<CollectionReference<Map<String, dynamic>>> getBuysReference() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeId = data['storeId'];
    return FirebaseFirestore.instance.collection("stores").doc(storeId).collection("buys");
  }

  List<BuyModel> getBuys() => _buys;
  setBuys(List<BuyModel> buys) {
    _buys.clear();
    _buys.addAll(buys);
  }

  addItemToBuys(BuyModel item) => _buys.add(item);

  editItemInBuyById(String id, BuyModel item) {
    int index = _buys.indexWhere((p) => p.id == id);
    _buys[index] = item;
  }

  Future<BuyModel> deleteBuy(BuyModel buyModel) async {
    CollectionReference snapshot = await getBuysReference();
    await snapshot.doc(buyModel.id).delete();
    return buyModel;
  }

  removeItemByIndexFromBuys(int index) => _buys.removeAt(index);

  getTotalPriceOfBuys() => getBuys().map((b) => b.priceOfBuy * b.quantity).sum;
  getTotalPriceOfSells() => getBuys().map((b) => b.priceOfSell * b.quantity).sum;

//#### END BUYS ACTION METHODS ###//
}