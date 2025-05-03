import 'dart:io';
import 'package:library_cli_app/models/book.dart';
import 'package:library_cli_app/services/library_service.dart';

// instance service (otomatis load data)
final libraryService = LibraryService();

void main() {
  print("===== Aplikasi Manajemen Perpustakaan CLI =====");

  while (true) {
    print("\nMenu: ");
    print("1. Tambah buku baru.");
    print("2. Lihat semua buku (urut judul).");
    print("3. Cari buku (berdasarkan ISBN).");
    print("4. Pinjam buku.");
    print("5. Kembalikan buku.");
    print("6. Keluar.");
    stdout.write("Pilih opsi (1-6): ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case "1":
        addBookUI();
        break;
      case "2":
        viewAllBooksUI();
        break;
      case "3":
        findBookUI();
        break;
      case "4":
        borrowBookUI();
        break;
      case "5":
        returnBookUI();
        break;
      case "6":
        print("Menyimpan data dan keluar");
        // Data sudah disimpan secara otomatis setiap ada perubahan
        print("Terimakasih");
        exit(0);
      default:
        print("pilihan tidak valid");
    }
  }
}

// helper untuk membaca input (non-null)
String readInput(String prompt) {
  String? input;
  while (input == null || input.isEmpty) {
    stdout.write(prompt);
    input = stdin.readLineSync();
    if (input == null || input.isEmpty) {
      print("Input tidakboleh kosong");
    }
  }
  return input;
}

// UI tambah buku
void addBookUI() {
  print("----- Tambah Buku Baru -----");
  String isbn = readInput("ISBN: ");
  String title = readInput("title: ");
  String author = readInput("author: ");

  String? errorMessage = libraryService.addBook(
    isbn: isbn,
    title: title,
    author: author,
  );

  if (errorMessage != null) {
    print("Error: $errorMessage");
  }
  // pesan sukses sudah ada di service
}

// UI lihat semua buku
void viewAllBooksUI() {
  print("\n----- Daftar Semua Buku (urut judul) -----");
  List<Book> books = libraryService.getAllBooksSortedByTitle();

  if (books.isEmpty) {
    print("Belum ada buku di perpustakaan");
  } else {
    for (final book in books) {
      print("- ${book.toSummaryString()}");
    }
  }
}

// UI cari buku
void findBookUI() {
  print("\n----- Cari Buku -----");
  String isbn = readInput("Masukkan ISBN buku yang dicari: ");

  Book? book = libraryService.findBookByIsbn(isbn);

  if (book == null) {
    print("Buku dengan ISBN $isbn tidak ditemukan");
  } else {
    print("Buku ditemukan:");
    print(book);
  }
}

// UI pinjam buku
void borrowBookUI() {
  print("\n----- Pinjam Buku -----");
  String isbn = readInput("Tuliskan ISBN buku yang ingin dipinjam: ");
  String borrowerName = readInput("Masukkan nama peminjam: ");

  String message = libraryService.borrowBook(
    isbn: isbn,
    borrowerName: borrowerName,
  );

  print(message);
}

// UI kembalikan buku
void returnBookUI() {
  print("\n----- Kembalikan Buku -----");
  String isbn = readInput("Masukkan ISBN buku yang ingin dikembalikan: ");

  String message = libraryService.returnBook(isbn: isbn);
  print(message);
}
