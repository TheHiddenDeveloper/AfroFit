import 'package:get/get.dart';

class WorkoutController extends GetxController {
  var beginnerProgress = 0.0.obs;
  var intermediateProgress = 0.0.obs;
  var advancedProgress = 0.0.obs;

  void increaseProgress(String level) {
    switch (level) {
      case "Beginner":
        if (beginnerProgress.value < 1.0) {
          beginnerProgress.value += 0.1;
        }
        break;
      case "Intermediate":
        if (intermediateProgress.value < 1.0) {
          intermediateProgress.value += 0.1;
        }
        break;
      case "Advanced":
        if (advancedProgress.value < 1.0) {
          advancedProgress.value += 0.1;
        }
        break;
    }
  }
}
