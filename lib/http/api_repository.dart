import 'dart:convert';
import 'dart:io';

import 'package:abtxt/http/dio_client.dart';
import 'package:abtxt/utils/app_utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as my_get;
import 'package:get_storage/get_storage.dart';

enum HttpRequestType {
  get,
  post,
  postFormData,
  put,
  delete,
  upload,
  download,
  singleFileUpload
}

class HttpRepository {
  static CancelToken _cancelToken = CancelToken();

  static void onReceiveProgress(int received, int total) {
    if (total != -1) {
      /*setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });*/
    }
  }

  static Future<ResponseData> apiRequest(
      HttpRequestType requestType, String urlString,
      {dynamic requestBodydata,
      // List<File>? files,
      File? file,
      FormData? formDatas,
      String? savePath,
      bool isPop = false}) async {
    ResponseData? responseData;
    try {
      Response<dynamic>? response;
      switch (requestType) {
        case HttpRequestType.get:
          response = await DioClient.dioConfig()
              .get(urlString, cancelToken: _cancelToken);
          break;
        case HttpRequestType.post:
          response = await DioClient.dioConfig().post(urlString,
              data: requestBodydata, cancelToken: _cancelToken);
          break;
        case HttpRequestType.postFormData:
          response = await DioClient.dioConfig()
              .post(urlString, data: formDatas, cancelToken: _cancelToken);
          break;
        case HttpRequestType.delete:
          response = await DioClient.dioConfig()
              .delete(urlString, cancelToken: _cancelToken);
          break;
        case HttpRequestType.upload:
          response = await DioClient.dioFileConfig()
              .post(urlString, data: formDatas, cancelToken: _cancelToken);
          break;
        case HttpRequestType.singleFileUpload:
          final FormData data = FormData.fromMap(
              {'file': await MultipartFile.fromFile(file!.path)});
          response = await DioClient.dioFileConfig()
              .post(urlString, data: data, cancelToken: _cancelToken);
          break;
        case HttpRequestType.download:
          response = await DioClient.dioConfig().download(urlString, savePath,
              cancelToken: _cancelToken, onReceiveProgress: onReceiveProgress);
          break;
        case HttpRequestType.put:
          response = await DioClient.dioConfig()
              .put(urlString, data: requestBodydata, cancelToken: _cancelToken);
          break;
      }

      responseData = ResponseData(
          success: true,
          data: ('$response'),
          statusCode: response?.statusCode,
          message: response?.statusMessage);
    } on DioException catch (e) {
      var error = jsonDecode('${e.response}');
      if (e.response?.statusCode == 401) {
        if (!_cancelToken.isCancelled) {
          _cancelToken.cancel("Cancelled due to 401 Unauthorized");
        }

        // Reset the token for future requests
        _cancelToken = CancelToken();

        var box = GetStorage();
        await box.erase();
        my_get.Get.toNamed('/');
        AppUtils.showErrorToast(message: 'Unauthorized');
        return ResponseData(success: false, data: {}, message: 'Unauthorized');

      } else if (e.response?.statusCode == 409) {
        AppUtils.infoAlert(message: "${e.response?.data["message"]}");
      } else if (e.response?.statusCode == 404) {
        if ('$error'.contains('Already Running status is avalable') == true) {
        } else if ('$error'.contains('Already New status is avalable') ==
            true) {
        } else if ('$error'.contains('This account is finished!') == true) {
        } else if ('$error'.contains('Already completed status is avalable') ==
            true) {
        } else if ('$error'.contains(
                'Wages paid in this challan number, So you cannot remove this item!') ==
            true) {
        } else {
          AppUtils.infoAlert(message: "${e.response?.data["message"]}");
        }
      } else if ('${e.message}'.contains('The connection errored')) {
        AppUtils.showErrorToast(
            message: 'Network issue! Please check your internet connection');
      } else if ('$error'.contains('Click New Button') == true) {
      } else if ('$error'.contains('Create New weaving Account') == true) {
      } else if ('$error'.contains('no ruuning data') == true) {
      } else if ('$error'.contains('No Account found') == true) {
      } else if ('$error'.contains('No data found!') == true) {
      } else if ('$error'.contains('No matching data found') == true) {
      } else if (e.response?.statusCode == 406) {
        true;
      } else {
        AppUtils.showErrorToast(message: '${e.response}');
      }
      responseData = ResponseData(
          success: false,
          data: ('${e.response}'),
          statusCode: e.response?.statusCode,
          message: DioClient.errorHandling(e).toString());
      DioClient.dioClose();
    }
    return responseData;
  }
}

class ResponseData {
  dynamic data;
  bool success;
  int? statusCode;
  String? message;

  ResponseData(
      {required this.data,
      required this.success,
      this.statusCode,
      this.message});

  @override
  String toString() {
    return 'success: $success, data: $data, statusCode: $statusCode, message: $message';
  }
}
