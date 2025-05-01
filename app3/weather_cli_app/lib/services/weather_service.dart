import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  // base url untuk API OpenWeather
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  final String _apiKey = 'YOUR_API_KEY';

  // fungsi ASYNCHRONOUS untuk mendapatkan data cuaca
  // mengembalikan Future<Weather>, artinya fungsi ini akan
  // menghasilkan object weather di masa depan
  Future<Weather> getWeather(String cityName) async {
    // membangun url lengkap dengan query paramaters (kota dan API key)
    final Uri uri = Uri.parse("$_baseUrl?q=$cityName&appid=$_apiKey&lang=id");

    try {
      // melakukan HTTP GET request. 'await' akan menjeda eksekusi
      // di dalam fungsi ini sampai request selesai dan mendapatkan respon.
      // http.get() mengembalikan Future<http.Response>
      print("mengambil data dari $uri"); //loggin url
      final response = await http.get(uri);

      // periksa status code response
      if (response.statusCode == 200) {
        // decode body respons (String JSON) menjadi Map Dart
        final Map<String, dynamic> data = jsonDecode(response.body);
        // parse map menjadi object Weather menggunakan factory constructor
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        // jika kota tidak ditemukan (kode 404 not found)
        throw Exception("Kota '$cityName' tidak ditemukan");
      } else if (response.statusCode == 401) {
        // jika API key tidak valid (kode 401 unathorized)
        throw Exception(
          "Api key tidak valid atau tidak ada, coba periksa kembali API key anda",
        );
      } else {
        throw Exception(
          "Gagal mendapatkan data cuaca, status code: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } on SocketException {
      // menangkap error jika tidak ada koneksi internet
      throw Exception(
        "Tidak ada koneksi internet atau server tidak terjangkau",
      );
    } on FormatException catch (e) {
      // menangkap error dari Weather.fromJson jika parsing gagal
      throw Exception("gagal memproses data dari server: ${e.message}");
    } catch (e) {
      // menangkap error tak terduga lainnya
      print("error tak terduga di weather service: $e"); //logging error
      throw Exception("Terjadi kesalahan: $e");
    }
  }
}
