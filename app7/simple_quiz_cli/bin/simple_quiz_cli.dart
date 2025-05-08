import 'dart:io';
import 'package:simple_quiz_cli/models/quiz.dart';
import 'package:simple_quiz_cli/models/question.dart';
import 'package:simple_quiz_cli/services/quiz_loader.dart';
import 'package:simple_quiz_cli/exceptions/quiz_exceptions.dart';

void main() {
  print("========== Selamat Datang di Aplikasi Quiz CLI ==========");

  final loader = QuizLoader();
  final String filePath = "data/quiz_questions.json";
  late Quiz quiz; // gunakan late karena diinisialisasi di try-catch

  // 1. Memuat pertanyaan
  try {
    List<Question> questions = loader.loadQuestionsFromFile(filePath);
    quiz = Quiz(questions: questions);
    print("\nKuis siap dimulai! Ada ${quiz.questions.length} pertanyaan");
  } on QuizException catch (e) {
    // tangkap custom exception spesifik
    print("\nError memuat kuis: $e");
    print("Aplikasi akan keluar");
    exit(1); //keluar dengan kode error
  } catch (e) {
    // tangkap error umum lainnya
    print("Terjadi kesalahan tidak terduga saat memuat: $e");
    exit(1);
  }

  // 2. Jalankan kuis
  print("Tekan enter untuk memulai...");
  stdin.readLineSync();

  while (!quiz.isFinished()) {
    try {
      Question currentQuestion = quiz.getCurrentQuestion();

      // tampilkan pertanyaan (polymorphism)
      currentQuestion.display();

      // baca jawaban pengguna
      String? userAnswer = stdin.readLineSync();
      if (userAnswer == null) {
        print("input tidak valid, coba lagi");
        continue; // ulangi pertanyaan yang sama
      }

      // submit jawaban dan tangani hasilnya
      bool isCorrect = quiz.submitAnswer(userAnswer);

      if (isCorrect) {
        print("Jawaban benar");
      } else {
        print("Jawaban salah");
      }

      print("Skor sementara: ${quiz.score}");

      // beri jeda sebelum pertanyaan berikutnya
      if (!quiz.isFinished()) {
        print("\nTekan enter untuk pertanyaan berikutnya...");
        stdin.readLineSync();
      }
    } on InvalidAnswerFormatException catch (e) {
      // tangkap error format jawaban dari Quiz.submitAnswer
      print("\nError jawaban: $e");
      print("Silahkan ulangi pertanyaan ini");
      // jangan naikkan index, pertanyaan diulang
    } on NoMoreQuestionsException {
      // Seharusnya tidak terjadi dalam loop ini, tapi ini sebagai pengaman
      print("Kuis sudah selesai");
      break;
    } catch (e) {
      print("\nTerjadi kesalahan tak terduga saat kuis");
      break; // berhenti jika ada error aneh
    }
  }

  // 3. Tampilkan hasil akhir
  print("\n======== Kuis Selesai ========");
  Map<String, dynamic> result = quiz.getResult();
  int finalScore = result['score'];
  int totalQuestions = result['totalQuestions'];
  Duration duration = result['duration'];

  print("Skor akhir: $finalScore dari $totalQuestions pertanyaan");
  print(
    "Waktu pengerjaan ${duration.inMinutes} menit ${duration.inSeconds.remainder(60)} detik",
  );
  print("Terimakasih sudah bermain");
}
