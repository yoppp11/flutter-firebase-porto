import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collectionName = 'users';

  Future<Map<String, dynamic>?> getDetail(String docId) async {
    String uid = auth.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> doc = await firestore
        .collection(collectionName)
        .doc(uid)
        .collection('money_history')
        .doc(docId)
        .get();

    return doc.data();
  }
}
