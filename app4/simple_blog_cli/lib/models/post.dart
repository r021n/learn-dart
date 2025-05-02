class Post {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;

  // Constructor
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  // Factory constructor untuk membuat Post dari Map (JSON)
  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        author: json['author'] as String,
        // parsing string ISO 8601 dari JSON menjadi objek DateTime
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
    } catch (e) {
      print("error parsing json into Post object: $e");
      print("received JSON: $json");
      throw FormatException(
        "Gagal memparsing data dari JSON menjadi object Post: $e",
      );
    }
  }

  // method untuk mengubah Post menjadi Map(json)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      // konversi DateTime menjadi String format ISO 8601 agar bisa disimpan di json
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // representasi ringkas daftar blog
  String toSummaryString() {
    // format tanggal supaya mudah dibaca
    String formattedDate =
        "${createdAt.day}-${createdAt.month}-${createdAt.year}";
    return "ID: $id | Judul: $title | Penulis: $author | Tanggal: $formattedDate";
  }

  // representasi detail daftar blog
  @override
  String toString() {
    String formattedDate =
        "${createdAt.day}-${createdAt.month}-${createdAt.year} ${createdAt.hour}:${createdAt.minute}:${createdAt.second}";
    return '''
--- Detail Post (ID: $id) ---
Judul     : $title
Penulis   : $author
Tanggal   : $formattedDate
-----------------------------
Isi       :
$content
-----------------------------
''';
  }
}
