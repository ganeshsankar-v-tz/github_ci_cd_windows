import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainScreenController extends GetxController with StateMixin {
  RxInt selectedIndex = RxInt(0);
  var name = "".obs;
  var email = "".obs;

  @override
  void onInit() async {
    super.onInit();
    _initValue();
  }

  void _initValue() async {
    final box = GetStorage();
    name.value = box.read("name") ?? '';
  }
}
