import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_info/d_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';

import '../controllers/outcome_controller.dart';

class OutcomeView extends GetView<OutcomeController> {
  OutcomeView({Key? key}) : super(key: key);
  OutcomeController outcomeC = Get.put(OutcomeController());
  TextEditingController Csearch = TextEditingController();
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: AppColor.bg,
  //     appBar: AppBar(
  //       titleSpacing: 0,
  //       title: Row(
  //         children: [
  //           Text('Pengeluaran'),
  //           Expanded(
  //               child: SizedBox(
  //             width: 80,
  //             height: 75,
  //             child: Padding(
  //               padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
  //               child: TextField(
  //                 // controller: Csearch,
  //                 onTap: () async {
  //                   DateTime? result = await showDatePicker(
  //                     context: context,
  //                     initialDate: DateTime.now(),
  //                     firstDate: DateTime(2022, 01, 01),
  //                     lastDate: DateTime(DateTime.now().year + 1),
  //                   );
  //                   if (result != null) {
  //                     Csearch.text = DateFormat('yyyy-MM-dd').format(result);
  //                   }
  //                 },
  //                 decoration: InputDecoration(
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(16),
  //                       borderSide: BorderSide.none,
  //                     ),
  //                     filled: true,
  //                     fillColor: AppColor.chart.withOpacity(0.5),
  //                     isDense: true,
  //                     hintText: '2024-06-01',
  //                     hintStyle: TextStyle(color: Colors.white),
  //                     contentPadding:
  //                         const EdgeInsets.symmetric(horizontal: 16),
  //                     suffixIcon: IconButton(
  //                       onPressed: () {
  //                         // hisC.search(userC.data.idUser, Csearch.text);
  //                       },
  //                       icon: const Icon(Icons.search),
  //                       color: Colors.white,
  //                     )),
  //                 textAlignVertical: TextAlignVertical.center,
  //                 style: const TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ))
  //         ],
  //       ),
  //     ),
  //     body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  //         stream: outcomeC.streamDataOutcome(),
  //         builder: (context, snapshot) {
  //           if (snapshot.connectionState == ConnectionState.waiting) {
  //             return const Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }
  //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //             return const Center(
  //               child: Text('Data masih kosong'),
  //             );
  //           }
  //           return ListView.builder(
  //               itemCount: snapshot.data!.docs.length,
  //               itemBuilder: (context, index) {
  //                 var docOut = snapshot.data!.docs[index];
  //                 Map<String, dynamic> outcome = docOut.data();
  //                 menuOption(String value) {
  //                   if (value == 'update') {
  //                     Get.toNamed(Routes.UPDATE, arguments: docOut.id);
  //                   } else {
  //                     outcomeC.deleteHistory(docOut.id);
  //                   }
  //                 }

  //                 return Card(
  //                   color: AppColor.primary,
  //                   elevation: 4,
  //                   margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
  //                       index == snapshot.data!.docs.length - 1 ? 16 : 8),
  //                   child: InkWell(
  //                     borderRadius: const BorderRadius.all(Radius.circular(12)),
  //                     onTap: () =>
  //                         Get.toNamed(Routes.DETAIL, arguments: docOut.id),
  //                     child: Row(
  //                       children: [
  //                         const SizedBox(
  //                           width: 16,
  //                         ),
  //                         Text(
  //                           AppFormat.date(outcome['date']),
  //                           style: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 16),
  //                         ),
  //                         Expanded(
  //                             child: Text(
  //                           AppFormat.currency(outcome['total'].toString()),
  //                           style: const TextStyle(
  //                               color: Colors.white,
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 16),
  //                           textAlign: TextAlign.end,
  //                         )),
  //                         PopupMenuButton<String>(
  //                           itemBuilder: (context) => [
  //                             const PopupMenuItem(
  //                               value: 'update',
  //                               child: Text('Update'),
  //                             ),
  //                             const PopupMenuItem(
  //                               value: 'delete',
  //                               child: Text('Delete'),
  //                             ),
  //                           ],
  //                           onSelected: (value) {
  //                             menuOption(value);
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Text('Pengeluaran'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: Csearch,
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
                    hintText: 'Pilih Tanggal',
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    suffixIcon: IconButton(
                      onPressed: () {
                        outcomeC.performSearch(Csearch.text);
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        var future = outcomeC.searchFuture.value;
        return future == null
            ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: outcomeC.streamDataOutcome(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Data masih kosong'),
                    );
                  }
                  return buildListView(snapshot.data!.docs);
                },
              )
            : FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Data tidak ditemukan'),
                    );
                  }
                  return buildListView(snapshot.data!.docs);
                },
              );
      }),
    );
  }

  Widget buildListView(List<DocumentSnapshot<Map<String, dynamic>>> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        var docOut = docs[index];
        Map<String, dynamic> outcome = docOut.data()!;
        menuOption(String value) async {
          if (value == 'update') {
            Get.toNamed(Routes.UPDATE, arguments: docOut.id);
          } else if (value == 'delete') {
            bool? yes = await DInfo.dialogConfirmation(
                context, 'Hapus', 'Yakin untuk menghapus?');
            if (yes ?? false) {
              outcomeC.deleteHistory(docOut.id);
              Get.back();
            }
          }
        }

        return Card(
          color: AppColor.primary,
          elevation: 4,
          margin: EdgeInsets.fromLTRB(
              16, index == 0 ? 16 : 8, 16, index == docs.length - 1 ? 16 : 8),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            onTap: () {
              Get.toNamed(Routes.DETAIL, arguments: docOut.id);
            },
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    const Text(
                      'Tanggal',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      AppFormat.date(outcome['date']),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      AppFormat.currency(outcome['total'].toString()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      textAlign: TextAlign.end,
                    ),
                  ],
                )),
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
      },
    );
  }
}
