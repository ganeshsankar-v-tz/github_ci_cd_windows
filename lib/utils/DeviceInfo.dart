import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;

    return windowsInfo.deviceId;
  }
}
