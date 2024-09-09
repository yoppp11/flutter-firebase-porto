import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';

import '../controllers/recurring_controller.dart';

class RecurringView extends GetView<RecurringController> {
  RecurringView({Key? key}) : super(key: key);
  RecurringController outcomeC = Get.put(RecurringController());
  TextEditingController Csearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text('Pengeluaran Rutin'),
            Expanded(
                child: SizedBox(
              width: 80,
              height: 75,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: TextField(
                  // controller: Csearch,
                  onTap: () async {
                    DateTime? result = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022, 01, 01),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );
                    if (result != null) {
                      Csearch.text = DateFormat('yyyy-MM-dd').format(result);
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColor.chart.withOpacity(0.5),
                      isDense: true,
                      hintText: '2024-06-01',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // hisC.search(userC.data.idUser, Csearch.text);
                        },
                        icon: const Icon(Icons.search),
                        color: Colors.white,
                      )),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ))
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: outcomeC.streamDataRecurring(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'Data masih kosong',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  double cumulativeBalance = 0.0;
                  var docOut = snapshot.data!.docs[index];
                  Map<String, dynamic> outcome = docOut.data();
                  double amount = double.parse(outcome['total'].toString());
                  if (outcome['type'] == 'Pemasukan') {
                    cumulativeBalance += amount;
                  } else {
                    cumulativeBalance -= amount;
                  }
                  menuOption(String value) {
                    if (value == 'update') {
                      Get.toNamed(Routes.UPDATE, arguments: docOut.id);
                    } else {
                      outcomeC.deleteRecurring(docOut.id);
                    }
                  }

                  return Card(
                    color: AppColor.primary,
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                        index == snapshot.data!.docs.length - 1 ? 16 : 8),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      onTap: () =>
                          Get.toNamed(Routes.DETAIL, arguments: docOut.id),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppFormat.date(outcome['date']),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Expanded(
                              child: Text(
                            AppFormat.currency(outcome['total']),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.end,
                          )),
                          Text(
                            AppFormat.currency(
                              cumulativeBalance.toString(),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          PopupMenuButton<String>(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'update',
                                child: Text('Update'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                            onSelected: (value) {
                              menuOption(value);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
