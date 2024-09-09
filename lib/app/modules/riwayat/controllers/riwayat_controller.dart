import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RiwayatController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionName = 'users';
  int? selectedMonth;
  int? selectedYear;

  final _saldoAwal = 0.0.obs;
  double get saldoAwal => _saldoAwal.value;
  setSaldoAwal(n) => _saldoAwal.value = n;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamHistory() async* {
    String uid = auth.currentUser!.uid;

    yield* await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .orderBy('date', descending: false)
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

  void updateSelectedDate(int? month, int? year) {
    selectedMonth = month;
    selectedYear = year;
    update();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataMonth() async* {
    String uid = auth.currentUser!.uid;
    String start = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedYear!, selectedMonth!, 1));
    String end = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedYear!, selectedMonth! + 1, 1));
    yield* await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThan: end)
        .orderBy('date', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamPreviousData() async* {
    String uid = auth.currentUser!.uid;
    String startOfMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(selectedYear!, selectedMonth!, 1));
    yield* await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .where('date', isLessThan: startOfMonth)
        .orderBy('date', descending: false)
        .snapshots();
  }
}
