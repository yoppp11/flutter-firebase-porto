import 'package:get/get.dart';

import '../controllers/add_history_controller.dart';

class AddHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddHistoryController>(
      () => AddHistoryController(),
    );
  }
}
