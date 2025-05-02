import 'dart:io';
import 'package:simple_blog_cli/models/post.dart';
import 'package:simple_blog_cli/services/post_service.dart';

// instance service (otomatis load data)
final postService = PostService();

void main() {
  print("===== Aplikasi Blog CLI =====");

  while (true) {
    print("\nMenu: ");
    print("1. Tambah Post Baru");
    print("2. Lihat Semua Judul Post (terbaru dulu)");
    print("3. Lihat Detail Post");
    print("4. Hapus Post");
    print("5. Keluar");
    stdout.write("Pilih Opsi(1-5): ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addPostUI();
        break;
      case '2':
        viewAllPostsUI();
        break;
      case '3':
        viewPostDetailUI();
        break;
      case '4':
        deletePostUI();
        break;
      case '5':
        print("Menyimpan data dan keluar...");
        // data sudah disimpan secara otomatis ketika ada add/delete
        print("Terimakasih");
        exit(0);
      default:
        print("Pilihan tidak valid");
    }
  }
}

// UI Untuk Menambah post
void addPostUI() {
  print("\n---- Tambah Post Baru ----");
  stdout.write("Judul Post: ");
  String title = stdin.readLineSync() ?? "";
  stdout.write("Isi Konten: ");
  String content = stdin.readLineSync() ?? "";
  stdout.write("Penulis: ");
  String author = stdin.readLineSync() ?? "";

  if (title.isEmpty || content.isEmpty || author.isEmpty) {
    print("Judul, Isi, dan Penulis tidak boleh kosong");
    return;
  }

  postService.addPost(title: title, content: content, author: author);
  // pesan sukses sudah dituliskan pada service
}

// UI untuk melihat semua judul post
void viewAllPostsUI() {
  print("\n----- Daftar Semua Post (Terbaru Dulu) -----");
  // ambil post yang sudah diurutkan dari service
  List<Post> posts = postService.getAllPostsSortedByDate();

  if (posts.isEmpty) {
    print("Belum ada post yang tersimpan");
  } else {
    for (final post in posts) {
      // gunakan summary string dari model
      print("- ${post.toSummaryString()}");
    }
  }
}

// UI untuk melihat detai post
void viewPostDetailUI() {
  print("\n----- Lihat Detail Post -----");
  viewAllPostsUI();
  stdout.write("Masukkan ID post yang ingin dilihat: ");
  String? id = stdin.readLineSync();

  if (id == null || id.isEmpty) {
    print("ID tidak boleh kosong");
    return;
  }

  // cari post berdasarkan ID menggunakan service
  Post? post = postService.getPostById(id);

  if (post == null) {
    print("Post dengan ID $id tidak ditemukan");
  } else {
    // secara otomatis akan menampilkan post dengan method toString yang telah dioverride
    print(post);
  }
}

// UI untuk menghapus post
void deletePostUI() {
  print("\n---- Hapus Post ----");
  // tampilkan daftar ringkas dulu supaya user tahu id post yang akan dihapus
  viewAllPostsUI();
  final posts = postService.getAllPostsSortedByDate();
  if (posts.isEmpty) {
    return; // tidak ada yang bisa dihapus
  }

  stdout.write(
    "Masukkan ID post yang akan dihapus (atau kosongkan untuk batal): ",
  );
  String? id = stdin.readLineSync();

  if (id == null || id.isEmpty) {
    print("Penghapusan dibatalkan");
    return;
  }

  // coba hapus menggunakan service
  bool deleted = postService.deletePost(id);

  if (deleted) {
    print("Post dengan ID $id berhasil dihapus");
  } else {
    print("Gagal menghapus, post dengan ID $id tidak ditemukan");
  }
}
