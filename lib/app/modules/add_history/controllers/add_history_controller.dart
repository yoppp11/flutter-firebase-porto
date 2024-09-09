import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddHistoryController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) {
    _type.value = n;
    if (n == 'Pengeluaran Rutin') {
      setIsRecurring(true);
    } else {
      setIsRecurring(false);
    }
  }

  final _total = 0.0.obs;
  double get total => _total.value;
  setTotal(n) => _total.value = n;

  final _isRecurring = false.obs;
  bool get isRecurring => _isRecurring.value;
  setIsRecurring(n) => _isRecurring.value = n;

  void setRecurring(bool value) {
    _isRecurring.value = value;
  }

  void toggleRecurring() {
    _isRecurring.value = !_isRecurring.value;
  }

  final _items = <Map<String, dynamic>>[].obs;
  List get items => _items.value;
  addItems(n) {
    _items.value.add(n);
    count();
  }

  deleteItems(i) {
    _items.value.removeAt(i);
    count();
  }

  count() {
    _total.value = items.map((e) => e['price']).toList().fold(
        0.0,
        (previousValue, element) =>
            double.parse(previousValue.toString()) + double.parse(element));
    update();
  }

  Future<bool> addDataHistory(String userId, String date, String type,
      String total, String item) async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('money_history')
          .add({
        'userId': uid,
        'date': date,
        'type': type,
        'total': total,
        'item': item,
      });
      Get.back();
      return true;
    } catch (e) {
      print(e);
      Get.snackbar('Terjadi Kesalahan', 'Pastikan semua data telah diisi.');
      return false;
    }
  }
}
