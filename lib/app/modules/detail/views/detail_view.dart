import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_firebase_2/app/data/app_color.dart';
import 'package:learn_firebase_2/app/data/app_format.dart';
import 'package:learn_firebase_2/app/modules/detail/controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          titleSpacing: 0,
          title: FutureBuilder<Map<String, dynamic>?>(
              future: controller.getDetail(Get.arguments.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Data Tidak Ditemukan',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                String dateDetail = snapshot.data!['date'];
                var typeDetail = snapshot.data!['type'];

                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppFormat.date(dateDetail),
                      ),
                    ),
                    typeDetail == 'Pemasukan'
                        ? const Icon(Icons.south_west,
                            color: Color.fromARGB(255, 155, 255, 158))
                        : Icon(Icons.north_east, color: Colors.red[300]),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                );
              }),
        ),
        body: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getDetail(Get.arguments.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null) {
              return const Center(
                child:
                    Text('data tidak dapat ditampilkan, karena ada kesalahan'),
              );
            } else {
              List<dynamic> detailsDynamic;
              if (snapshot.data!['item'] is String) {
                detailsDynamic = jsonDecode(snapshot.data!['item']);
              } else {
                detailsDynamic = snapshot.data!['item'];
              }

              List<Map<String, dynamic>> details = detailsDynamic.map((item) {
                return Map<String, dynamic>.from(item);
              }).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: const Text(
                      'Total',
                      style: TextStyle(
                          color: AppColor.chart,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Text(
                      AppFormat.currency(snapshot.data!['total'].toString()),
                      style: TextStyle(color: AppColor.chart, fontSize: 26),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      width: 90,
                      height: 5,
                      decoration: BoxDecoration(
                          color: AppColor.chart,
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: ListView.separated(
                    itemCount: details.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white,
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Text(details[index]['name'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20))),
                            Text(AppFormat.currency(details[index]['price']),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ],
                        ),
                      );
                    },
                  ))
                ],
              );
            }
          },
        ));
  }
}
