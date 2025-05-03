import 'dart:io';
import 'dart:convert';
import '../models/book.dart';

class LibraryService {
  List<Book> _books = [];
  final String _filePath = "data/library.json";

  // default durasi peminjaman (contoh: 14 hari)
  final Duration defaultLoanDuration = const Duration(days: 14);

  // constructor: muat data saat service dibuat
  LibraryService() {
    loadLibrary();
  }

  // muat data buku dari file
  void loadLibrary() {
    try {
      final file = File(_filePath);
      if (!file.existsSync()) {
        _books = [];
        return;
      }

      String jsonString = file.readAsStringSync();
      if (jsonString.isEmpty) {
        _books = [];
        return;
      }

      List<dynamic> jsonList = jsonDecode(jsonString);
      _books =
          jsonList
              .map((json) => Book.fromJson(json as Map<String, dynamic>))
              .toList();
      print("Data perpustakaan berhasil dimuat dari $_filePath");
    } catch (e) {
      print("Error saat memuat data perpustakaan: $e");
      _books = []; // memulai dengan list kosong jika gagal load data
    }
  }

  // simpan data buku ke file
  void saveLibrary() {
    try {
      List<Map<String, dynamic>> jsonList =
          _books.map((book) => book.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      final file = File(_filePath);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      file.writeAsStringSync(jsonString);
    } catch (e) {
      print("Error saat menyimpan data perpustakaan: $e");
    }
  }

  // menambah buku baru, cek duplikasi ISBN
  // mengembalikan pesan error jika gagal, null jika sukses
  String? addBook({
    required String isbn,
    required String title,
    required String author,
  }) {
    // trim input untuk menghindari spasi tidka terlihat
    isbn = isbn.trim();
    title = title.trim();
    author = author.trim();

    if (isbn.isEmpty || title.isEmpty || author.isEmpty) {
      return "ISBN, Judul, dan Penulis tidak boleh kosong";
    }

    // cek apakah isbn sudah ada
    if (_books.any((book) => book.isbn == isbn)) {
      return "Error: Buku dengn ISBN $isbn sudah ada";
    }

    final newBook = Book(isbn: isbn, title: title, author: author);
    _books.add(newBook);
    saveLibrary();
    print("Buku $title dengan ISBN $isbn berhasil ditambahkan");
    return null; // success
  }

  // mendapatkan semua buku. diurutkan berdasarkan judul (case-insensitive)
  List<Book> getAllBooksSortedByTitle() {
    List<Book> sortedBooks = List.from(
      _books,
    ); // menyalin data _books supaya data tersebut aman/tidak berubah
    sortedBooks.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );
    return sortedBooks;
  }

  // mencari buku berdasarkan ISBN
  Book? findBookByIsbn(String isbn) {
    isbn = isbn.trim(); // memastikan tidak ada spasi
    try {
      // gunakan firstWhere untuk mencari, tangkap error jika tidak ketemu
      return _books.firstWhere((book) => book.isbn == isbn);
    } catch (e) {
      return null; // kembalikan null jika tidak ditemukan
    }
  }

  // meminjam buku
  // mengembalikan pesan status (success atau error)
  String borrowBook({required String isbn, required String borrowerName}) {
    borrowerName = borrowerName.trim();
    if (borrowerName.isEmpty) {
      return "Nama peminjam tidak boleh kosong";
    }

    Book? book = findBookByIsbn(isbn);

    if (book == null) {
      return "Error: buku dengan ISBN $isbn tidak ditemukan";
    }

    if (book.isBorrowed) {
      return "Error: Buku dengan ISBN $isbn sedang dipinjam ${book.borrowerName}";
    }

    // hitung tanggal jatuh tempo
    DateTime dueDate = DateTime.now().add(defaultLoanDuration);
    // panggil method 'borrow' pada object Book
    book.borrow(borrowerName, dueDate);
    saveLibrary();
    String formattedDueDate = "${dueDate.day}-${dueDate.month}-${dueDate.year}";
    return "Buku dengan ISBN $isbn berhasil dipinjam oleh $borrowerName, tanggal jatuh tempo peminjaman: $formattedDueDate";
  }

  // mengembalikan buku
  // mengembalikan status (sukses atau error)
  String returnBook({required String isbn}) {
    Book? book = findBookByIsbn(isbn);

    if (book == null) {
      return "Error: Buku dengan ISBN $isbn tidak ditemukan";
    }

    if (!book.isBorrowed) {
      return "Error: Buku dengan ISBN $isbn sedang tidak sedang dalam status dipinjam";
    }

    // panggil methor returnBook pada object Book
    book.returnBook();
    saveLibrary();
    return "Buku dengan ISBN $isbn berhasil dikembalikan";
  }
}
