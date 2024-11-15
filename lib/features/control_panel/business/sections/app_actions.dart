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

  String getTimeFilterStatement(){
    int dayFrom = getTemporaryTimeFrom().toDate().day;
    int monthFrom = getTemporaryTimeFrom().toDate().month;
    int yearFrom = getTemporaryTimeFrom().toDate().year;

    int dayTo = getTemporaryTimeTo().toDate().day;
    int monthTo = getTemporaryTimeTo().toDate().month;
    int yearTo = getTemporaryTimeTo().toDate().year;

    // get number of days between from and to
    int days = DateTime(yearTo, monthTo, dayTo)
       .difference(DateTime(yearFrom, monthFrom, dayFrom))
       .inDays + 1;

    return "${days == 0 ? "في يوم $dayFrom شهر $monthFrom سنة $yearFrom" : "من يوم $dayFrom شهر $monthFrom سنة $yearFrom الى يوم $dayTo شهر $monthTo سنة $yearTo"} ${days == 0 ? "" : days == 1 ? "أي لمدة يوم واحد" : days == 2 ? "أي لمدة يومين اثنين" : days > 2 && days < 11 ?  "أي لمدة $days أيام" : "أي لمدة $days يوم"}";
  }
}