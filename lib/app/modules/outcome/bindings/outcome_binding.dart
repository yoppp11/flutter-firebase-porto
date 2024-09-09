import 'package:get/get.dart';

import '../controllers/outcome_controller.dart';

class OutcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OutcomeController>(
      () => OutcomeController(),
    );
  }
}
