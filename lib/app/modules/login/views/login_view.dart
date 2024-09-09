import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/data/app_asset.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/modules/register/views/register_view.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bg,
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(),
                  Form(
                    key: controller.formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Image.asset(
                            AppAsset.logo,
                            width: 150,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              TextFormField(
                                controller: controller.emailC,
                                validator: (value) =>
                                    controller.validateFormEmail(value!),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'email',
                                    hintStyle: TextStyle(color: Colors.white),
                                    fillColor:
                                        AppColor.primary.withOpacity(0.5),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    // labelText: 'email',
                                    // labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none)),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: controller.passC,
                                validator: (value) =>
                                    controller.validateFormPassword(value!),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: Colors.white),
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'password',
                                    hintStyle: TextStyle(color: Colors.white),
                                    fillColor:
                                        AppColor.primary.withOpacity(0.5),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    filled: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none)),
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: 150,
                                height: 40,
                                child: Obx(() => ElevatedButton(
                                    onPressed: () {
                                      if (controller.isLoading.isFalse) {
                                        controller.login();
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => AppColor.primary)),
                                    child: controller.isLoading == false
                                        ? const Text(
                                            'LOGIN',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : const Text(
                                            'LOADING ...',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => RegisterView());
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Belum punya akun? ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            'Register',
                            style: TextStyle(
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
