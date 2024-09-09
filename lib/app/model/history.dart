import 'dart:convert';

History HistoryFromJson(String str) => History.fromJson(json.decode(str));

String HistoryToJson(History data) => json.encode(data.toJson());

class History {
  String date;
  String item;
  String total;
  String type;
  String userId;

  History({
    required this.date,
    required this.item,
    required this.total,
    required this.type,
    required this.userId,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        date: json["date"],
        item: json["item"],
        total: json["total"],
        type: json["type"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "item": item,
        "total": total,
        "type": type,
        "userId": userId,
      };
}

// class MoneyHistory {
//   final String id;
//   final String date;
//   final String type;
//   final String total;
//   final Map<String, dynamic> detail;

//   MoneyHistory(
//       {required this.id,
//       required this.date,
//       required this.type,
//       required this.total,
//       required this.detail});

//   factory MoneyHistory.fromDocument(DocumentSnapshot doc) {
//     return MoneyHistory(
//       id: doc.id,
//       date: doc['date'],
//       type: doc['type'],
//       total: doc['total'],
//       detail: Map<String, dynamic>.from(doc['detail']),
//     );
//   }
// }
