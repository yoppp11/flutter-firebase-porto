import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class OutcomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionName = 'users';

  Rxn<Future<QuerySnapshot<Map<String, dynamic>>>> searchFuture = Rxn();

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataOutcome() async* {
    String uid = auth.currentUser!.uid;
    yield* await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .where('type', isEqualTo: 'Pengeluaran')
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> deleteHistory(String docId) async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .doc(docId)
        .delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchIncomeByDate(
      String date) async {
    String uid = auth.currentUser!.uid;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('money_history')
        .where('type', isEqualTo: 'Pengeluaran')
        .where('date', isEqualTo: date)
        .get();
  }

  void performSearch(String date) {
    searchFuture.value = searchIncomeByDate(date);
  }
}
