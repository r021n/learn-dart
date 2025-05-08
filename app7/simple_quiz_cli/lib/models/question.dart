abstract class Question {
  final String id;
  final String text;

  // Constructor untuk abstract class (dipanggil oleh subclass)
  Question({required this.id, required this.text});

  // Abstract method untuk menampilkan pertanyaan ke pengguna
  // Setiap subclass HARUS menyediakan implementasinya sendiri
  void display();

  // Abstract method untuk memeriksa jawaban pengguna
  // Mengembalikan true jika benar, false jika salah
  // Bisa melempar InvalidAnswerFormatException jika format salah
  bool checkAnswer(String userAnswer);
}
