import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/data/app_asset.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RegisterController regC = Get.put(RegisterController());
    return Scaffold(
        backgroundColor: AppColor.bg,
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(),
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
                          const SizedBox(
                            height: 50,
                          ),
                          Column(
                            children: [
                              TextFormField(
                                controller: regC.nameC,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: 'name',
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
                                controller: regC.emailC,
                                validator: (value) =>
                                    regC.validateFormEmail(value!),
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
                                controller: regC.passC,
                                validator: (value) =>
                                    regC.validateFormPassword(value!),
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
                                    // labelText: 'password',
                                    // labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(24),
                                        borderSide: BorderSide.none)),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                    onPressed: () {
                                      regC.register();
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => AppColor.primary)),
                                    child: const Text(
                                      'REGISTER',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            'Login',
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
