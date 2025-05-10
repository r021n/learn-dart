// memungkinkan kita menulis fungsi yang bisa bekerja dengan berbagai tipe data dengan aman
// untuk contoh ini, kita batasi T ke Product dan turunannya
import 'dart:io';

import '../models/product.dart';

T? findItemById<T extends Product>(List<T> items, String id) {
  try {
    // Karena T adalah extends dari product, maka 'item' akan punya properti 'id'
    return items.firstWhere((item) => item.id == id);
  } catch (e) {
    // firstwhere akan melempar state error jika elemen yang dicari tidak ditemukan
    return null;
  }
}

// fungsi generic untuk mencetak semua item dalam list
// menggunakan method toString() dari item
void printAllItems<T>(List<T> items, String title) {
  print("\n--- $title ---");
  if (items.isEmpty) {
    print("Tidak ada item.");
    return;
  }
  for (final item in items) {
    print(
      item.toString(),
    ); // Bergantung pada implementasi toString() masing-masing T
    print("-" * 20);
  }
}

// fungsi generik untuk mengambil input pilihan dari pengguna
T? selectItemFromList<T>(
  List<T> items,
  String prompt,
  String Function(T item) displayFunction,
) {
  if (items.isEmpty) {
    print("Tidak ada pilihan tersedia");
    return null;
  }

  print(prompt);
  for (int i = 0; i < items.length; i++) {
    print(
      "${i + 1}. ${displayFunction(items[i])}",
    ); // gunakan displayFunction untuk menampilkan item
  }
  stdout.write("Pilih nomor (atau 0 untuk batal): ");
  String? input = stdin.readLineSync();
  int? choice = int.tryParse(input ?? '');

  if (choice == null || choice < 0 || choice > items.length) {
    print("Pilihan tidak valid");
    return null;
  }
  if (choice == 0) return null; // batal

  return items[choice - 1];
}
