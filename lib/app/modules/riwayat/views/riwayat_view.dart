import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';

import '../controllers/riwayat_controller.dart';

class RiwayatView extends StatefulWidget {
  RiwayatView({Key? key}) : super(key: key);

  @override
  State<RiwayatView> createState() => _RiwayatViewState();
}

class _RiwayatViewState extends State<RiwayatView> {
  RiwayatController riwC = Get.put(RiwayatController());

  TextEditingController Csearch = TextEditingController();

  double saldoAwal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Text('History'),
              Expanded(
                child: SizedBox(
                  width: 80,
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      children: [
                        DropdownButton<int?>(
                          value: riwC.selectedMonth,
                          hint: Text(
                            riwC.selectedMonth != null
                                ? DateFormat.MMMM()
                                    .format(DateTime(0, riwC.selectedMonth!))
                                : "Pilih Bulan",
                            style: TextStyle(color: Colors.white),
                          ),
                          items: List.generate(12, (index) {
                            return DropdownMenuItem(
                              value: index + 1,
                              child: Text(
                                DateFormat.MMMM()
                                    .format(DateTime(0, index + 1)),
                              ),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              riwC.selectedMonth = value;
                              riwC.updateSelectedDate(value, riwC.selectedYear);
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<int?>(
                          value: riwC.selectedYear,
                          hint: Text(
                            riwC.selectedYear != null
                                ? riwC.selectedYear.toString()
                                : "Pilih Tahun",
                            style: TextStyle(color: Colors.white),
                          ),
                          items: List.generate(3, (index) {
                            int year = DateTime.now().year - 2 + index;
                            return DropdownMenuItem(
                              value: year,
                              child: Text(year.toString()),
                            );
                          }),
                          onChanged: (value) {
                            setState(() {
                              riwC.selectedYear = value;
                              riwC.updateSelectedDate(
                                  riwC.selectedMonth, value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<RiwayatController>(builder: (controller) {
          return riwC.selectedMonth == null && riwC.selectedYear == null
              ? streamDataBulananDefault()
              : streamDataBulanan();
        }));
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>
      streamDataBulananDefault() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: riwC.streamHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                'Data Masih Kosong',
              ),
            );
          }
          double cumulativeBalance = 0.0;
          double totalIncome = 0.0;
          double totalExpense = 0.0;

          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> history = doc.data();
            double amount = double.parse(history['total'].toString());
            if (history['type'] == 'Pemasukan') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }
          }

          double balance = totalIncome - totalExpense;

          return Column(children: [
            // Card untuk menampilkan total saldo
            Card(
              color: AppColor.primary,
              margin: const EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Saldo Akhir:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppFormat.currency(balance.toString()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var docLength = snapshot.data!.docs.length;
                    var docHistory = snapshot.data!.docs[index];
                    Map<String, dynamic> history = docHistory.data();
                    double amount = double.parse(history['total'].toString());
                    if (history['type'] == 'Pemasukan') {
                      cumulativeBalance += amount;
                    } else {
                      cumulativeBalance -= amount;
                    }
                    return Card(
                      color: AppColor.primary,
                      elevation: 4,
                      margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
                          index == docLength - 1 ? 16 : 8),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        onTap: () => Get.toNamed(Routes.DETAIL,
                            arguments: docHistory.id),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            history['type'] == 'Pemasukan'
                                ? const Icon(
                                    Icons.south_west,
                                    color: Color.fromARGB(255, 155, 255, 158),
                                  )
                                : const Icon(
                                    Icons.north_east,
                                    color: Colors.red,
                                  ),
                            const SizedBox(
                              width: 16,
                            ),
                            Column(
                              children: [
                                Text(
                                  AppFormat.date(
                                    history['date'],
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  AppFormat.currency(
                                    history['total'].toString(),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                AppFormat.currency(
                                  cumulativeBalance.toString(),
                                ),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            IconButton(
                                onPressed: () =>
                                    riwC.deleteHistory(docHistory.id),
                                icon: const Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ]);
        });
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> streamDataBulanan() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: riwC.streamDataMonth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: Text(
                'Data Masih Kosong',
              ),
            );
          }

          double totalIncome = 0.0;
          double totalExpense = 0.0;

          return Column(children: [
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: riwC.streamPreviousData(),
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
                  for (var doc in snapshot.data!.docs) {
                    Map<String, dynamic> history = doc.data();
                    double amount = double.parse(history['total'].toString());
                    if (history['type'] == 'Pemasukan') {
                      totalIncome += amount;
                    } else {
                      totalExpense += amount;
                    }
                  }
                  saldoAwal = totalIncome - totalExpense;

                  return Card(
                    color: AppColor.primary,
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saldo Awal:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppFormat.currency(saldoAwal.toString()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: riwC.streamDataMonth(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Data Masih Kosong'));
                  }

                  double cumulativeBalance = saldoAwal;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var docLength = snapshot.data!.docs.length;
                          var docHistory = snapshot.data!.docs[index];

                          Map<String, dynamic> history = docHistory.data();
                          double amount =
                              double.parse(history['total'].toString());
                          if (history['type'] == 'Pemasukan') {
                            cumulativeBalance += amount;
                          } else {
                            cumulativeBalance -= amount;
                          }

                          return Card(
                            color: AppColor.primary,
                            elevation: 4,
                            margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8,
                                16, index == docLength - 1 ? 16 : 8),
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              onTap: () => Get.toNamed(Routes.DETAIL,
                                  arguments: docHistory.id),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  history['type'] == 'Pemasukan'
                                      ? const Icon(
                                          Icons.south_west,
                                          color: Color.fromARGB(
                                              255, 155, 255, 158),
                                        )
                                      : const Icon(
                                          Icons.north_east,
                                          color: Colors.red,
                                        ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        AppFormat.date(
                                          history['date'],
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        AppFormat.currency(
                                          history['total'].toString(),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      AppFormat.currency(
                                        cumulativeBalance.toString(),
                                      ),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () =>
                                          riwC.deleteHistory(docHistory.id),
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        color: Colors.red,
                                      ))
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                })
          ]);
        });
  }
}
