import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppActions {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  Timestamp  _TEMPORARY_TIME_FROM =  Timestamp.now();
  Timestamp _TEMPORARY_TIME_TO = Timestamp.now();

  void setTemporaryTimeFrom(Timestamp time) => _TEMPORARY_TIME_FROM = time;
  void setTemporaryTimeTo(Timestamp time) => _TEMPORARY_TIME_TO = time;

  Timestamp getTemporaryTimeFrom() => _TEMPORARY_TIME_FROM;
  Timestamp getTemporaryTimeTo() => _TEMPORARY_TIME_TO;

  Future<String> getStoreName() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeName = data['storeName'];
    return storeName;
  }
}