// ignore_for_file: unused_catch_clause

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart'; // ✅ Needed for Snackbar
import 'package:get_storage/get_storage.dart';
import 'package:mcq_mentor/utils/api_endpoint.dart';

/// A comprehensive API service class using Dio
/// Supports JSON and multipart/form-data requests
class ApiService {
  final dio.Dio _dio = dio.Dio();
  String? _authToken;

  /// Base URL
  final String _baseUrl = ApiEndpoint.baseUrl;

  ApiService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    // Logging + Snackbar interceptor
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ Request [${options.method}] => PATH: ${options.path}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
              '✅ Response [${response.statusCode}] => PATH: ${response.requestOptions.path}');
          debugPrint('Data: ${response.data}');

          // 🔹 If API sends "message" and it's not a GET request, show it
          if (response.requestOptions.method != 'GET' &&
              response.data is Map &&
              response.data['message'] != null &&
              response.data['message'].toString().isNotEmpty) {
            // Get.snackbar(
            //   'Message',
            //   response.data['message'].toString(),
            //   snackPosition: SnackPosition.BOTTOM,
            // );
          }

          return handler.next(response);
        },
        onError: (dio.DioException e, handler) {
          debugPrint(
              '❌ Error [${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          debugPrint('Error Data: ${e.response?.data}');

          // 🔹 Try to extract error message
          final errorMessage = e.response?.data is Map
              ? e.response?.data['message'] ?? e.message
              : e.message;

          if (errorMessage != null) {
            Get.snackbar(
              'Error',
              errorMessage.toString(),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Get.theme.colorScheme.errorContainer,
              colorText: Get.theme.colorScheme.onError
            );
          }

          return handler.next(e);
        },
      ),
    );
  }

  /// GET request
Future<dio.Response> get(String path,
    {Map<String, dynamic>? queryParameters}) async {
  try {
    // Check for authorization token and add to headers if present
    await getAuthToken(); // This updates _dio.options.headers if a token exists

    // Now, perform the GET request with the updated headers
    return await _dio.get(
      path,
      queryParameters: queryParameters,
    );
  } on dio.DioException catch (e) {
    rethrow;
  }
}


  /// Get token from local storage
  Future<String?> getAuthToken() async {
    final prefs =  GetStorage();
    _authToken = prefs.read('access_token');
    if (_authToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_authToken';
    }
    return _authToken;
  }

  /// Clear token
  Future<void> clearAuthToken() async {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
    final prefs = GetStorage();
    await prefs.remove('access_token');
  }

  // / POST request (JSON or FormData)

/// POST request (JSON or FormData)
Future<dio.Response> post(
  String path,
  dynamic data, {
  Map<String, dynamic>? queryParameters,
  bool needToken = false, // ✅ token required only if true
}) async {
  try {
    _dio.options.headers['Accept'] = "application/json";
    _dio.options.headers['Content-Type'] =
        (data is dio.FormData) ? 'multipart/form-data' : 'application/json';

    // Load token from local storage
    await getAuthToken();

    // If token is required but missing, throw error
    if (needToken && _authToken == null) {
      throw Exception("Access token is required for this request!");
    }

    // Add token if exists
    if (_authToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_authToken';
    }

    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  } on dio.DioException catch (e) {
    rethrow;
  }
}


  /// PUT request (JSON or FormData)
  Future<dio.Response> put(String path, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      _dio.options.headers['Content-Type'] =
          (data is dio.FormData) ? 'multipart/form-data' : 'application/json';
      return await _dio.put(path,
          data: data, queryParameters: queryParameters);
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<dio.Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } on dio.DioException catch (e) {
      rethrow;
    }
  }

  /// Multipart POST (for file uploads like images)
  Future<dio.Response> postMultipart(
    String path,
    Map<String, dynamic> data, {
    String? fileKey,
    File? file,
  }) async {
    try {
      dynamic requestData;
      dio.Options options;

      if (file != null && fileKey != null) {
        // Prepare multipart form data
        requestData = dio.FormData.fromMap({
          ...data,
          fileKey: await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        });

        options = dio.Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            if (_authToken != null) 'Authorization': 'Bearer $_authToken',
          },
        );
      } else {
        // Send plain JSON
        requestData = data;

        options = dio.Options(
          headers: {
            'Content-Type': 'application/json',
            if (_authToken != null) 'Authorization': 'Bearer $_authToken',
          },
        );
      }

      return await _dio.post(
        path,
        data: requestData,
        options: options,
      );
    } on dio.DioException catch (e) {
      debugPrint('❌ Multipart POST error: ${e.response?.data}');
      rethrow;
    }
  }
}