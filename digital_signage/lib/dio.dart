import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Server {
  final dio = Dio();

  final baseUrl = 'http://localhost:3000/signage';

  Future<List<dynamic>> getBanners() async {
    try {
      final res = await dio.get('$baseUrl/get_banners');
      if (res.statusCode == 200) {
        debugPrint('Current list:');
        return res.data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
