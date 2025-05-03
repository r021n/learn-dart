class Book {
  final String isbn;
  final String title;
  final String author;
  bool isBorrowed; // status peminjaman
  String? borrowerName; // nama peminjam (nullable)
  DateTime? dueDate; // tanggal jatuh tempo (nullable)

  // constructor untuk buku baru (awal pasti belum dipinjam)
  Book({
    required this.isbn,
    required this.title,
    required this.author,
    this.isBorrowed = false, // Defaultnya false saat buku baru ditambahkan
    this.borrowerName, // Otomatis null awalnya
    this.dueDate, // Otomatis null awalnya
  });

  // factory constructor dari JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    try {
      return Book(
        isbn: json['isbn'] as String,
        title: json['title'] as String,
        author: json['author'] as String,
        isBorrowed: json['isBorrowed'] as bool,
        // baca borrower name, jika null di JSON maka akan jadi null di dart
        borrowerName: json['borrowerName'] as String?,
        // baca dueDate, jika null di JSON maka null di dart, jika ada, parse
        dueDate:
            json['dueDate'] == null
                ? null
                : DateTime.parse(json['dueDate'] as String),
      );
    } catch (e) {
      print("Error parsing JSON to book object: $e");
      print("received JSON: $json");
      throw FormatException("Gagal mem-parsing data buku dari JSON: $e");
    }
  }

  // method ke JSON
  Map<String, dynamic> toJson() {
    return {
      'isbn': isbn,
      'title': title,
      'author': author,
      'isBorrowed': isBorrowed,
      'borrowerName': borrowerName, // bisa null
      // jika dueDate null, simpan null, jika tidak, simpan string ISO 8601
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  // method untuk menandai buku sebagai dipinjam
  void borrow(String name, DateTime due) {
    if (!isBorrowed) {
      isBorrowed = true;
      borrowerName = name;
      dueDate = due;
    } else {
      // seharusnya tidak terjadi jika service benar, tapi ini sebagai pengaman saja
      print("Error Internal: mencoba meminjam buku yang sudah dipinjam");
    }
  }

  // method untuk menandai buku sebagai dikembalikan
  void returnBook() {
    if (isBorrowed) {
      isBorrowed = false;
      borrowerName = null;
      dueDate = null;
    } else {
      // pengaman
      print("Error Internal: mencoba mengembalikan buku yang tidak dipinjam");
    }
  }

  // representasi ringkas untuk daftar
  String toSummaryString() {
    String status =
        isBorrowed ? "Dipinjam oleh ${borrowerName ?? '???'}" : "tersedia";
    return 'ISBN: $isbn | Judul: $title | Penulis: $author  | Status: $status';
  }

  // representasi detail
  @override
  String toString() {
    String statusDetail;
    if (isBorrowed) {
      String formattedDueDate =
          dueDate != null
              ? "${dueDate!.day}-${dueDate!.month}-${dueDate!.year}"
              : "Tanggal tidak valid";
      statusDetail =
          "Status  : Dipinjam oleh ${borrowerName ?? 'tidak diketahui'}\nJatuh Tempo: $formattedDueDate";
    } else {
      statusDetail = "Status  : Tersedia";
    }

    return '''
--- Detail Buku (ISBN: $isbn) ---
Judul   : $title
Penulis : $author
$statusDetail
---------------------------------
''';
  }
}
