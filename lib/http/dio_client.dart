import 'dart:io';

import 'package:abtxt/http/http_urls.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_storage/get_storage.dart';

//import 'package:pretty_dio_logger/pretty_dio_logger.dart';
final options = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),
  policy: CachePolicy.request,
  hitCacheOnErrorExcept: [401, 403],
  maxStale: const Duration(days: 1),
  priority: CachePriority.normal,
  cipher: null,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: false,
);

class DioClient extends DioMixin implements Dio {
  static dynamic dioConfig() {
    var box = GetStorage();
    var token = box.read('token');
    //  print('Authorization: Bearer $token');
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: HttpUrl.baseUrl,
        connectTimeout: const Duration(seconds: 180),
        receiveTimeout: const Duration(seconds: 300),
        followRedirects: true,
        headers: {
          "Authorization": 'Bearer $token',
          'Accept': 'application/json, text/plain'
        },
        contentType: 'application/json',
      ),
    );
    dio.interceptors.add(DioCacheInterceptor(options: options));
    //  dio.interceptors.add(PrettyDioLogger());

    /*dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );*/

    return dio;
  }

  static dynamic dioFileConfig() {
    var box = GetStorage();
    var token = box.read('token');
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: HttpUrl.baseUrl,
        connectTimeout: const Duration(seconds: 180),
        receiveTimeout: const Duration(seconds: 300),
        followRedirects: true,
        headers: {
          "Authorization": 'Bearer $token',
          'Accept': 'application/json, text/plain'
        },
        contentType: 'multipart/form-data',
      ),
    );

    /*dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );*/

    return dio;
  }

  static dynamic dioClose() {
    final Dio dio = Dio();
    dio.close(force: true);
  }

  static dynamic errorHandling(DioException e) {
    print(e);

    /// When the server response, but with a incorrect status, such as 404, 503
    if (e.type == DioExceptionType.badResponse) {
      return DioExceptionType.badResponse;
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Please check your internet connection';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Unable to connect to the server';
    } else if (e.type == DioExceptionType.badCertificate) {
      return 'Unauthorized access';
    } else if (e.type == DioExceptionType.unknown) {
      return 'Something went wrong';
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request cancelled';
    } else {
      return 'Something went wrong';
    }
  }

  static List<dynamic>? listOfMultiPart(List<File> file) {
    final List<dynamic> multiPartValues = [];
    for (File element in file) {
      multiPartValues.add(MultipartFile.fromFile(
        element.path,
        // filename: element.path.split('/').last,
      ));
    }
    return multiPartValues;
  }

  // @override
  // Future<Response> download(String urlPath, savePath,
  //     {ProgressCallback? onReceiveProgress,
  //     Map<String, dynamic>? queryParameters,
  //     CancelToken? cancelToken,
  //     bool deleteOnError = true,
  //     String lengthHeader = Headers.contentLengthHeader,
  //     Object? data,
  //     Options? options}) {
  //   // TODO: implement download
  //   throw UnimplementedError();
  // }
}
