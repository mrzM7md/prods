import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppActions {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');

  Future<String> getStoreName() async {
    var data = (await collectionRef.doc(user.uid).get()).data() as Map<String, dynamic>;
    String storeName = data['storeName'];
    return storeName;
  }
}