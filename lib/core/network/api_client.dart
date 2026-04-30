import 'package:dio/dio.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://your-api-url.com", // 👈 هتغيره
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }

  // GET
  Future<Response> get(String path) async {
    try {
      return await dio.get(path);
    } catch (e) {
      rethrow;
    }
  }

  // POST
  Future<Response> post(String path, dynamic data) async {
    try {
      return await dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}