import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/modules/login/views/login_view.dart';

import '../controllers/add_history_controller.dart';

class AddHistoryView extends GetView<AddHistoryController> {
  AddHistoryView({Key? key}) : super(key: key);
  AddHistoryController addC = Get.put(AddHistoryController());
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  addHistory() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    bool success = await addC.addDataHistory(
      userId,
      addC.date,
      addC.type,
      addC.total.toString(),
      jsonEncode(addC.items),
    );
    if (success) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        Get.back(result: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return LoginView();
        }
        return buildScafold(context);
      },
    );
  }

  Scaffold buildScafold(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          title: const Text(
            'Tambah Baru',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          // backgroundColor: AppColor.primary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Tanggal',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Obx(() => Text(
                      addC.date,
                      style: const TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColor.secondary),
                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                      (states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Atur border radius sesuai kebutuhan
                      ),
                    ),
                    padding:
                        MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                      (states) => const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4), // Atur padding sesuai kebutuhan
                    ),
                  ),
                  icon: const Icon(
                    Icons.event,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Pilih',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    DateTime? result = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024, 01, 01),
                        lastDate: DateTime(DateTime.now().year + 1));

                    if (result != null) {
                      addC.setDate(DateFormat('yyyy-MM-dd').format(result));
                    }
                  },
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Tipe',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            DropdownButtonFormField(
              dropdownColor: AppColor.bg,
              style: const TextStyle(color: Colors.white),
              value: addC.type,
              items: ['Pemasukan', 'Pengeluaran'].map((e) {
                return DropdownMenuItem(child: Text(e), value: e);
              }).toList(),
              onChanged: (value) {
                addC.setType(value);
              },
              decoration: InputDecoration(
                hoverColor: Colors.white,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.white)),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Sumber/Objek Pengeluaran',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: controllerName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
                hintText: 'Pemasukan',
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Nominal',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: controllerPrice,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                hintStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 14),
                hintText: 'Rp. ',
                border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 16,
            ),
            // Obx(() => CheckboxListTile(
            //     title: const Text(
            //       'Pengeluaran Rutin',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     value: addC.isRecurring,
            //     onChanged: (value) => addC.setRecurring(value ?? false))),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    addC.addItems({
                      'name': controllerName.text,
                      'price': controllerPrice.text
                    });
                    controllerName.clear();
                    controllerPrice.clear();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColor.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Tambah ke Items',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  )),
            ),
            const SizedBox(
              height: 24,
            ),
            Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                    color: AppColor.chart,
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Items',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: GetBuilder<AddHistoryController>(
                builder: (_) {
                  return Wrap(
                      spacing: 8,
                      children: List.generate(_.items.length, (index) {
                        return Chip(
                          label: Text(_.items[index]['name']),
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: AppColor.secondary,
                          deleteIcon: Icon(Icons.clear),
                          deleteIconColor: Colors.white,
                          onDeleted: () {
                            _.deleteItems(index);
                          },
                        );
                      }));
                },
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                const Text(
                  'Total: ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 8,
                ),
                Obx(() => Text(
                      AppFormat.currency(addC.total.toString()),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondary),
                    ))
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    addHistory();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => AppColor.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  )),
            )
          ],
        ));
  }
}
