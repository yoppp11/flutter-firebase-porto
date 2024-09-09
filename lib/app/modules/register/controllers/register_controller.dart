import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? validateFormEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return 'Email tidak valid!';
    }
    return null;
  }

  String? validateFormPassword(String value) {
    if (value.length < 8) {
      return 'Password minimal 8 karakter!';
    }
    return null;
  }

  void register() async {
    if (emailC.text.isNotEmpty &&
        passC.text.isNotEmpty &&
        nameC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        await firestore.collection('users').doc(credential.user!.uid).set({
          'name': nameC.text,
          'email': emailC.text,
          'uid': credential.user!.uid,
          'created_at': DateTime.now().toIso8601String(),
        });

        print(credential);
        isLoading.value = false;
        Get.offAllNamed(Routes.LOGIN);
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        print("Firebase Auth Exception: ${e.code}");
        Get.snackbar('Error', e.message ?? 'Terjadi kesalahan');
      } catch (e) {
        isLoading.value = false;
        print("General Exception: $e");
        Get.snackbar('Error', 'Terjadi kesalahan');
      }
    }
  }
}
