import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RecurringController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionName = 'users';
  String collectionpath = 'money_history';

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataRecurring() async* {
    String uid = auth.currentUser!.uid;
    yield* await firestore
        .collection(collectionName)
        .doc(uid)
        .collection(collectionpath)
        .where('type', isEqualTo: 'Pengeluaran Rutin')
        .orderBy('date', descending: true)
        .snapshots();
  }

  void deleteRecurring(String docId) async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection(collectionName)
        .doc(uid)
        .collection(collectionpath)
        .doc(docId)
        .delete();
  }
}
