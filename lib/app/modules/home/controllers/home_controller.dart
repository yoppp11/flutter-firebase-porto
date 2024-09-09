import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:learn_firebase_2/app/routes/app_pages.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String users = 'users';

  void signOut() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      String uid = auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> docUser =
          await firestore.collection(users).doc(uid).get();
      return docUser.data();
    } catch (e) {
      print(e);
      return null;
    }
  }

  final _monthIncome = 0.0.obs;
  double get monthIncome => _monthIncome.value;

  final _monthOutcome = 0.0.obs;
  double get monthOutcome => _monthOutcome.value;

  final _outcome = 0.0.obs;
  double get outcome => _outcome.value;

  final _monthRecurring = 0.0.obs;
  double get monthRecurring => _monthRecurring.value;

  final _monthBalance = 0.0.obs;
  double get monthBalance => _monthBalance.value;

  final _lastMonthBalance = 0.0.obs;
  double get lastMonthBalance => _lastMonthBalance.value;
  setLastMonthBalance(n) => _lastMonthBalance.value = n;

  List<String> get days => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<String> monthText() {
    DateTime today = DateTime.now();
    List<String> last30Days = [];
    for (int i = 29; i >= 0; i--) {
      DateTime day = today.subtract(Duration(days: i));
      last30Days.add(DateFormat('yyyy-MM-dd').format(day));
    }
    return last30Days;
  }

  final _monthExpense = List<double>.filled(30, 0.0).obs;

  List<double> get monthExpense => _monthExpense.value;

  Future<void> calculateMonthData() async {
    String uid = auth.currentUser!.uid;
    DateTime today = DateTime.now();
    DateTime startDate = today.subtract(Duration(days: 29));

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('date',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(startDate))
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        DateTime date = DateTime.parse(doc['date']);
        int dayIndex = today.difference(date).inDays;
        double total = double.parse(doc['total'].toString());
        if (doc['type'] == 'Pengeluaran') {
          _monthExpense[29 - dayIndex] += total;
        }
      }

      update();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataHome() async* {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    String firstDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    String lastDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));
    yield* await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataSaldoAwal() async* {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    String startOfLastMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month - 2, 1));
    String endOfLastMonth = DateFormat('yyyy-MM-dd')
        .format(DateTime(now.year, now.month, 1).subtract(Duration(days: 1)));

    yield* await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type')
        .where('date', isGreaterThanOrEqualTo: startOfLastMonth)
        .where('date', isLessThanOrEqualTo: endOfLastMonth)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamDataUser() async* {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    String firstDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month - 2, 1));
    String lastDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));

    yield* await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type')
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamRecurring() async* {
    String uid = auth.currentUser!.uid;
    yield* await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type')
        .snapshots();
  }

  Future<void> calculateTotals() async {
    String uid = auth.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime startDate = now.subtract(Duration(days: 29));
    String firstDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 1));
    String lastDayOfMonth =
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month + 1, 0));

    QuerySnapshot incomeSnapshot = await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type', isEqualTo: 'Pemasukan')
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .get();

    QuerySnapshot expenseSnapshot = await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type', isEqualTo: 'Pengeluaran')
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
        .where('date', isLessThanOrEqualTo: lastDayOfMonth)
        .get();

    QuerySnapshot recurringSnapshot = await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('type', isEqualTo: 'Pengeluaran Rutin')
        .get();

    QuerySnapshot lastMonth = await firestore
        .collection(users)
        .doc(uid)
        .collection('money_history')
        .where('date',
            isGreaterThanOrEqualTo: DateFormat('yyyy-MM-dd').format(startDate))
        .get();

    for (var doc in incomeSnapshot.docs) {
      _monthIncome.value += double.parse(doc['total'].toString());
    }

    for (var doc in expenseSnapshot.docs) {
      _monthOutcome.value += double.parse(doc['total'].toString());
    }

    for (var doc in recurringSnapshot.docs) {
      _monthRecurring.value += double.parse(doc['total'].toString());
    }

    for (var doc in lastMonth.docs) {
      _lastMonthBalance.value += double.parse(doc['total'].toString());
    }

    _monthBalance.value = _monthIncome.value - _monthOutcome.value;
  }

  RxMap<String, dynamic> monthlyData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMonthlyData();
  }

  void fetchMonthlyData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    firestore
        .collection('users')
        .doc(uid)
        .collection('monthlyData')
        .doc('currentMonth')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        monthlyData.value = snapshot.data()!;
      } else {
        monthlyData.value = {};
      }
    });
  }
}
