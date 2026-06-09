import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:nuntium/config/routes.dart';

class WelcomeController extends GetxController {
  void onButtonPressed() {
    Get.offNamed(Routes.loginView);
  }
}
