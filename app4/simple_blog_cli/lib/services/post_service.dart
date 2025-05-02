import 'dart:io';
import 'dart:convert';
import 'dart:math';
import '../models/post.dart';

class PostService {
  List<Post> _posts = [];
  final String _filePath = 'data/posts.json';
  // Awalnya ID bisa dimulai dari 0 atau 1, tapi untuk menghindari konflik
  // saat load data yang mungkin ID nya sudah besar, kita gunakan cara lain
  // atau generate ID unik yang lebih robust (misal: UUID)
  // untuk simple CLI, kita pakai cara load max ID + 1
  int _nextIdCounter = 1; // akan diupdate setelah load

  // Constructor
  PostService() {
    loadPosts();
  }

  // helper untuk generate ID unik sederhana
  // pada aplikasi nyata, gunakan 'uuid'
  String _generateId() {
    // gunakan timestamp + counter sederhana untuk ID
    // ini tidak dijamin unik dalam skenario konkurensi tinggi
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final id = '$timestamp-${_nextIdCounter++}';
    return id;
  }

  // method untuk memuat Post dari file JSON
  void loadPosts() {
    try {
      final file = File(_filePath);
      if (!file.existsSync()) {
        print("File posts.json belum ada, memulai dengan daftar kosong");
        _posts = [];
        _nextIdCounter = 1; // Reset counter jika file baru
        return;
      }

      String jsonString = file.readAsStringSync();
      if (jsonString.isEmpty) {
        print("file posts.json kosong.");
        _posts = [];
        _nextIdCounter = 1;
        return;
      }

      List<dynamic> jsonList = jsonDecode(jsonString);
      _posts =
          jsonList
              .map(
                (jsonItem) => Post.fromJson(jsonItem as Map<String, dynamic>),
              )
              .toList();

      // **PENTING: Update _nextIdCounter berdasarkan ID tertinggi yang ada**
      // Ini mencegah duplikasi ID jika aplikasi ditutup dan dibuka kembali
      if (_posts.isNotEmpty) {
        // Ekstrak bagian counter dari ID yang ada untuk mendapatkan nilai max
        // asumsi format ID: "timestamp-counter"
        try {
          _nextIdCounter =
              _posts
                  .map((post) {
                    final parts = post.id.split('-');
                    // ambil bagian terakhir (counter), default ke 0 jika parsing gagal
                    return int.tryParse(parts.last) ?? 0;
                  })
                  .reduce(max) +
              1;
        } catch (e) {
          print(
            "Warning: gagal mengurai ID post yang ada untuk counter. menggunakan ID default",
          );
          // fallback jika format ID tidak sesuai atau ada error
          _nextIdCounter =
              (_posts.map((p) => p.id.hashCode).reduce(max) % 10000) +
              _posts.length +
              1;
        }
        // memastikan counter minimal 1
        if (_nextIdCounter <= 1) _nextIdCounter = 1;
      } else {
        _nextIdCounter = 1; // jika list kosong setelah load
      }
      print(
        "Post berhasil dimuat dari $_filePath. Next ID counter = $_nextIdCounter",
      );
    } catch (e) {
      print("error saat memuat post: $e");
      print("memulai dengan dafta post kosong");
      _posts = [];
      _nextIdCounter = 1;
    }
  }

  // method untuk menyimpan post ke file JSON
  void savePosts() {
    try {
      List<Map<String, dynamic>> jsonList =
          _posts.map((post) => post.toJson()).toList();
      String jsonString = jsonEncode(jsonList);
      final file = File(_filePath);

      // pastikan direktori ada
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }

      file.writeAsStringSync(jsonString);
    } catch (e) {
      print("error saat menyimpan post: $e");
    }
  }

  // menambah post baru
  void addPost({
    required String title,
    required String content,
    required String author,
  }) {
    final newPost = Post(
      id: _generateId(), // menggunakan id yang digenerate
      title: title,
      content: content,
      author: author,
      createdAt: DateTime.now(), // menggunakan waktu saat ini
    );
    _posts.add(newPost);
    savePosts();
    print("Post baru dengan id: ${newPost.id} berhasil ditambahkan");
  }

  // mendapatkan semua post diurutkan dari tanggal terbaru
  List<Post> getAllPostsSortedByDate() {
    // buat salinan list supaya list asli tidak termodifikasi
    List<Post> sortedPosts = List.from(_posts);
    // urutkan postlist (descending/terbaru dulu)
    sortedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedPosts;
  }

  // mencari post berdasarkan id unik nya
  // mengembalikan Post atau null jika tidak ditemukan
  Post? getPostById(String id) {
    try {
      // firstWhere akan melempar error jika tidak ditemukan,
      // jadi kita bungkus dalam try-catch atau gunakan cara lain
      return _posts.firstWhere((post) => post.id == id);
    } catch (e) {
      // jika tidak menemukan, firstWehere akan melempar StateError
      return null; // kembalikan null jika tidak ada post dengan id tersebut
    }
  }

  // menghapus post berdasarkan ID
  // mengembalikan true jika berhasil, false jika ID tidak ditemukan
  bool deletePost(String id) {
    final initialLength = _posts.length;
    // menghapus semua post yang memiliki ID yang cocok
    _posts.removeWhere((post) => post.id == id);

    // cek apakah ada post yang dihapus
    if (_posts.length < initialLength) {
      savePosts(); // simpan perubahan jika ada yang dihapus
      return true;
    } else {
      return false;
    }
  }
}
