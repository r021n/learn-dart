import 'dart:io';
import 'package:weather_cli_app/services/weather_service.dart';
import 'package:weather_cli_app/models/weather.dart';

// menjadikan main() menjadi async karena nanti akan memakai await
void main() async {
  // buka instance dari WeatherService
  final weatherService = WeatherService();

  print("===== Cek cuaca CLI =====");

  while (true) {
    stdout.write("masukkan nama kota (atau 'exit' untuk keluar): ");
    String? cityName = stdin.readLineSync();

    if (cityName == null || cityName.trim().isEmpty) {
      print("Nama kota tidak boleh kosong");
      continue; // melakukan loop
    }

    cityName = cityName.trim(); // untuk menghapus space awal/akhir

    if (cityName.toLowerCase() == "exit") {
      print("Terimakasih");
      break; // menghentikan CLI app
    }

    // menampilkan pesan loading
    print("mencari data cuaca untuk $cityName");

    // menggunakan try-catch untuk menangani error yang mungkin dilempar service
    try {
      // panggil service untuk mendapatkan data
      // gunakan 'await' karena getFuture() mengembalikan Future
      // eksekusi akan berhenti di pemanggilan fungsi ini sampai Future selesai
      Weather weather = await weatherService.getWeather(cityName);

      // jika berhasil, cetak hasilnya menggunakan toString() dari model
      print("$weather");
    } catch (e) {
      // tangkap error yang dilempar dari service atau model
      print("Error: $e");
    } finally {
      print(
        "-" * 20,
      ); // garis pemisah yang akan dijalankan baik saat sukses atau error
    }
  }
}
