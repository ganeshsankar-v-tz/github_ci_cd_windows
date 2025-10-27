import 'package:flutter_dotenv/flutter_dotenv.dart';

class HttpUrl {
 // static String baseUrl = 'http://apiabtex.tamilzorous.com/';
 //  static String imageBaseUrl = 'http://apiabtex.tamilzorous.com';
  static String products = '/products';
  static String baseUrl = dotenv.env['API_URL']!;
  // static String baseUrl = 'http://192.168.1.6:8000/';
}
