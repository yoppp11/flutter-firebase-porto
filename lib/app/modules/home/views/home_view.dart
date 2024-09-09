import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/data/app_asset.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/modules/add_history/views/add_history_view.dart';
import 'package:learn_firebase_2/app/modules/income/views/income_view.dart';
import 'package:learn_firebase_2/app/modules/outcome/views/outcome_view.dart';
import 'package:learn_firebase_2/app/modules/riwayat/views/riwayat_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = Get.put(HomeController());
  @override
  void initState() {
    controller.calculateTotals();
    controller.calculateMonthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: drawer(),
        backgroundColor: AppColor.bg,
        body: FutureBuilder<Map<String, dynamic>?>(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.data == null) {
                return Center(
                    child: ElevatedButton(
                        onPressed: () {
                          controller.signOut();
                        },
                        child: Text('Logout')));
              } else {
                String name = snapshot.data!['name'];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: Row(
                        children: [
                          Image.asset(AppAsset.profile),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hi,',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Builder(builder: (ctx) {
                            return Material(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.chart,
                              child: InkWell(
                                onTap: () {
                                  Scaffold.of(ctx).openEndDrawer();
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      Icon(Icons.menu, color: AppColor.primary),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.calculateTotals(),
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamDataUser(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              // if (!snapshot.hasData ||
                              //     snapshot.data!.docs.isEmpty) {
                              //   return const Center(
                              //     child: Text('Data masih kosong'),
                              //   );
                              // }
                              double outcome = 0.0;
                              double income = 0.0;
                              double saldoAkhir = 0.0;
                              for (var doc in snapshot.data!.docs) {
                                Map<String, dynamic> data = doc.data();
                                double total =
                                    double.parse(data['total'].toString());
                                if (data['type'] == 'Pengeluaran') {
                                  outcome += total;
                                } else {
                                  income += total;
                                }
                                saldoAkhir = income - outcome;
                              }
                              return ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 16),
                                children: [
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(16),
                                    elevation: 4,
                                    color: AppColor.primary,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              16, 12, 16, 0),
                                          child: Text('Saldo awal',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColor.bg)),
                                        ),
                                        StreamBuilder<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: controller
                                                .streamDataSaldoAwal(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              if (!snapshot.hasData ||
                                                  snapshot.data!.docs.isEmpty) {
                                                return const Center(
                                                  child:
                                                      Text('Data masih kosong'),
                                                );
                                              }
                                              double totalExpenses = 0.0;
                                              double totalIncome = 0.0;
                                              double balance = 0.0;
                                              for (var doc
                                                  in snapshot.data!.docs) {
                                                if (doc['type'] ==
                                                    'Pemasukan') {
                                                  double total = double.parse(
                                                      doc['total'].toString());
                                                  totalIncome += total;
                                                } else {
                                                  double total = double.parse(
                                                      doc['total'].toString());
                                                  totalExpenses += total;
                                                }
                                                balance =
                                                    totalIncome - totalExpenses;
                                                controller.setLastMonthBalance(
                                                    balance);
                                                saldoAkhir =
                                                    balance + saldoAkhir;
                                              }
                                              return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          16, 8, 16, 4),
                                                  child: Text(
                                                    AppFormat.currency(
                                                        controller
                                                            .lastMonthBalance
                                                            .toString()),
                                                    style: const TextStyle(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColor.bg),
                                                  ));
                                            }),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 0, 16, 0),
                                          child: Text(
                                            'Pengeluaran bulan ini',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.bg,
                                            ),
                                          ),
                                        ),
                                        Obx(() {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 0, 16, 0),
                                                child: Text(
                                                  AppFormat.currency(controller
                                                      .monthOutcome
                                                      .toString()),
                                                  style: const TextStyle(
                                                    color: AppColor.bg,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () => Get.to(RiwayatView()),
                                          child: Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                16, 0, 0, 26),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8))),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Selengkapnya',
                                                  style: TextStyle(
                                                      color: AppColor.primary),
                                                ),
                                                Icon(Icons.navigate_next,
                                                    color: AppColor.primary)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 80,
                                      height: 5,
                                      decoration: BoxDecoration(
                                          color: AppColor.chart,
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    'Pengeluaran 30 hari terakhir',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Obx(() => DChartBarO(
                                          areaColor:
                                              (group, ordinalData, index) =>
                                                  ordinalData.color,
                                          fillColor:
                                              (group, ordinalData, index) =>
                                                  AppColor.chart,
                                          groupList: [
                                            OrdinalGroup(
                                              color: Colors.white,
                                              id: '1',
                                              data: List.generate(30, (index) {
                                                return OrdinalData(
                                                  domain: controller
                                                      .monthText()[index],
                                                  measure: controller
                                                      .monthExpense[index],
                                                  color: AppColor.chart,
                                                );
                                              }),
                                            ),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text(
                                    'Perbandingan bulan ini',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        child: AspectRatio(
                                          aspectRatio: 16 / 9,
                                          child: Stack(
                                            children: [
                                              Obx(() => DChartPieO(
                                                    configRenderPie:
                                                        const ConfigRenderPie(
                                                      arcWidth: 20,
                                                    ),
                                                    data: [
                                                      OrdinalData(
                                                          domain: 'income',
                                                          measure: controller
                                                              .monthIncome,
                                                          color:
                                                              AppColor.primary),
                                                      OrdinalData(
                                                          domain: 'outcome',
                                                          measure: controller
                                                              .monthOutcome,
                                                          color: AppColor
                                                              .secondary),
                                                    ],
                                                  )),
                                              // Center(
                                              //     child: Text(
                                              //   // '${homeC.percentIncome}%',
                                              //   '50',
                                              //   style: const TextStyle(
                                              //       fontSize: 26,
                                              //       color: Colors.white),
                                              // )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: const BoxDecoration(
                                                    color: AppColor.primary),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text(
                                                'Pemasukan',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                decoration: const BoxDecoration(
                                                    color: AppColor.secondary),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              const Text('Pengeluaran',
                                                  style: TextStyle(
                                                      color: Colors.white))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          const Text(
                                            'Saldo saat ini: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            // AppFormat.currency(
                                            //     homeC.differentMonth.toString()),
                                            AppFormat.currency(
                                                saldoAkhir.toString()),
                                            style: const TextStyle(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                      ),
                    )
                  ],
                );
              }
            }));
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('Saldo awal',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.bg)),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamDataSaldoAwal(),
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
                double totalExpenses = 0.0;
                double totalIncome = 0.0;
                double balance = 0.0;
                for (var doc in snapshot.data!.docs) {
                  if (doc['type'] == 'Pemasukan') {
                    double total = double.parse(doc['total'].toString());
                    totalIncome += total;
                  } else {
                    double total = double.parse(doc['total'].toString());
                    totalExpenses += total;
                  }
                  balance = totalIncome - totalExpenses;
                  controller.setLastMonthBalance(balance);
                }
                return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      AppFormat.currency(
                          controller.lastMonthBalance.toString()),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColor.bg),
                    ));
              }),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              'Pengeluaran bulan ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.bg,
              ),
            ),
          ),
          Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    AppFormat.currency(controller.monthOutcome.toString()),
                    style: const TextStyle(
                      color: AppColor.bg,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () => Get.to(RiwayatView()),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 0, 26),
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Selengkapnya',
                    style: TextStyle(color: AppColor.primary),
                  ),
                  Icon(Icons.navigate_next, color: AppColor.primary)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Obx(() {
                    //         return Text(
                    //           userC.data.name ?? '',
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 20,
                    //           ),
                    //         );
                    //       }),
                    //       Obx(() {
                    //         return Text(
                    //           userC.data.email ?? '',
                    //           style: const TextStyle(
                    //             fontWeight: FontWeight.w300,
                    //             fontSize: 16,
                    //           ),
                    //         );
                    //       })
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      controller.signOut();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryView())?.then((value) {
                if (value ?? false) {
                  // homeC.getAnalysis(userC.data.idUser!);
                }
              });
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text('Tambah Baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Get.to(() => IncomeView());
            },
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: const Text('Pemasukan'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Get.to(() => OutcomeView());
            },
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: const Text('Pengeluaran'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Get.to(() => RiwayatView());
            },
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: const Text('Riwayat'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
