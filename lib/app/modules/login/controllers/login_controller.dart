import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

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

  void login() async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;
      try {
        UserCredential credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print("User Credential: $credential");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        isLoading.value = false;
        Get.offAllNamed(Routes.HOME);
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

  void logout() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed(Routes.LOGIN);
  }

  // @override
  // void onClose() {
  //   emailC.dispose();
  //   passC.dispose();
  //   super.onClose();
  // }
}
