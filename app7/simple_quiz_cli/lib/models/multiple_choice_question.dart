import 'dart:io';
import 'question.dart';
import '../exceptions/quiz_exceptions.dart';

// subclass untuk pertanyaan pilihan ganda
class MultipleChoiceQuestion extends Question {
  final List<String> options; // pilihan jawaban
  final int correctOptionIndex;

  // Constructor, memanggil constructor parent (Question) menggunakan 'super'
  MultipleChoiceQuestion({
    required String id,
    required String text,
    required this.options,
    required this.correctOptionIndex,
  }) : super(id: id, text: text); // memanggil constructor Question

  // menyediakan implementasi untuk abstract method display()
  @override
  void display() {
    print("\n------ Pertanyaan Pilihan Ganda ------");
    print("ID: $id");
    print("Pertanyaan: $text");
    for (int i = 0; i < options.length; i++) {
      // tampilkan option dengan angka 1, 2, 3, ......
      print("${i + 1}. ${options[i]}");
    }

    stdout.write("Jawaban Anda (Masukkan Nomor Pilihan): ");
  }

  // menyediakan implementasi untuk abstract method chackAnswer()
  @override
  bool checkAnswer(String userAnswer) {
    // validasi input, harus berupa angka dan dalam range pilihan
    int? answerIndex = int.tryParse(userAnswer);

    if (answerIndex == null ||
        answerIndex < 1 ||
        answerIndex > options.length) {
      throw InvalidAnswerFormatException(
        "Masukkan nomor pilihan antara 1 hingga ${options.length}",
      );
    }

    // konversi angka pilihan (1-based) ke index list (0-base)
    int selectedIndex = answerIndex - 1;

    // bandingkan dengan jawaban benar
    return selectedIndex == correctOptionIndex;
  }
}
