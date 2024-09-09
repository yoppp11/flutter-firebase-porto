import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String collectionName = 'users';

  final _date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  String get date => _date.value;
  setDate(n) => _date.value = n;

  final _type = 'Pemasukan'.obs;
  String get type => _type.value;
  setType(n) {
    _type.value = n;
  }

  final _total = 0.0.obs;
  double get total => _total.value;
  setTotal(n) => _total.value = n;

  final _items = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> get items => _items.value;
  addItems(Map<String, dynamic> n) {
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

  init(String docId) async {
    String uid = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> history = await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .doc(docId)
        .get();
    if (history.exists && history.data() != null) {
      setDate(history.data()!['date']);
      setType(history.data()!['type']);
      // List<dynamic> itemsDynamic = jsonDecode(history.data()!['item']);
      // _items.value = itemsDynamic.map((item) {
      //   return Map<String, dynamic>.from(item);
      // }).toList();
      List<dynamic> itemsDynamic;
      if (history.data()!['item'] is String) {
        itemsDynamic = jsonDecode(history.data()!['item']);
      } else {
        itemsDynamic = history.data()!['item'];
      }

      _items.value = itemsDynamic.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
      count();
    }
  }

  void updateDataHistory(String docId) async {
    String uid = auth.currentUser!.uid;
    await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .doc(docId)
        .update({
      'userId': uid,
      'date': _date.value,
      'type': _type.value,
      'total': _total.value,
      'item': _items.value,
    });
  }
}
