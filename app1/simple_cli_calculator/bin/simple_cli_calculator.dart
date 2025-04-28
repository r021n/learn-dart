import 'dart:io';
import 'package:simple_cli_calculator/calculator.dart';

void main() {
  print("===== Kalkulator CLI sederhana =====");

  while(true){
    try{
      stdout.write("Masukkan angka pertama: ");
      String? input1 = stdin.readLineSync();

    //   konversi tipe data input1
      double? num1 = double.tryParse(input1 ?? '');

      if(num1 == null){
        print("Input angka pertama tidak valid");
        continue;
      }

    //   meminta input operator
      stdout.write("Masukkan operator (+, -, *, /) atau 'exit' untuk keluar: ");
      String? operator = stdin.readLineSync();

    //   Periksa jika pengguna ingin keluar
      if(operator?.toLowerCase() == "exit"){
        print("Terimakasih telah menggunakan kalkulator");
        break;
      }

    //   meminta input angka kedua
      stdout.write("Masukkan angka kedua: ");
      String? input2 = stdin.readLineSync();
      double? num2 = double.tryParse(input2 ?? '');

      if(num2 == null) {
        print("Input angka kedua tidak valid");
        continue;
      }

      double result;

    //   memilih operasi berdasarkan operator
      switch(operator){
        case '+':
          result = add(num1, num2);
          break;
        case '-':
          result = substract(num1, num2);
          break;
        case '*':
          result = multiply(num1, num2);
          break;
        case '/':
          result = divide(num1, num2);
          break;
        default:
          print("operator tidak dikenal: $operator");
          continue;
      }

    //   menampilkan hasil jika valid
      if(!result.isNaN){
        print("Hasil $num1 $operator $num2 = $result");
      }
    } catch (e) {
      // menangkap error yang tidak terduga
      print("Terjadi error: $e . Silahkan coba lagi");
    }
    print("-" * 20);
  }
}