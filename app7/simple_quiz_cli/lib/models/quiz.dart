import 'question.dart';
import '../exceptions/quiz_exceptions.dart';

class Quiz {
  final List<Question> questions;
  int currentQuestionIndex;
  int score;
  final DateTime startTime;
  DateTime? endTime; // bersifat nullable karena diisi saat kuis selesai

  // static constant untuk status kuis (opsional, bisa juga string biasa)
  static const String STATUS_RUNNING = "Berjalan";
  static const String STATUS_FINISHED = "Selesai";

  Quiz({required this.questions})
    : currentQuestionIndex = 0,
      score = 0,
      startTime = DateTime.now() {
    // validasi awal: pastikan ada pertanyaan
    if (questions.isEmpty) {
      throw QuizLoadException("Tidak bisa memulai quiz tanpa pertanyaan");
    }
  }

  // mendapatkan pertanyaan saat ini
  Question getCurrentQuestion() {
    if (isFinished()) {
      // Lempar exception jika quiz sudah selesai
      throw NoMoreQuestionsException();
    }

    return questions[currentQuestionIndex];
  }

  // fungsi untuk memeriksa apakah kuis sudah selesai
  bool isFinished() {
    return currentQuestionIndex >= questions.length;
  }

  // mengajukan jawaban untuk pertanyaan saat ini
  // mengembalikan true jika benar, false jika salah
  bool submitAnswer(String userAnswer) {
    if (isFinished()) {
      print("Warning: Mencoba menjawab pertanyaan yang sudah selesai");
      return false;
    }

    Question currentQuestion = getCurrentQuestion();
    bool isCorrect = false;

    try {
      // panggil checkAnswer (polymorphism)
      // implementasi yang dipanggil tergantung tipe Object currentQuestion
      isCorrect = currentQuestion.checkAnswer(userAnswer);
      if (isCorrect) {
        score++; // tambah skor jika benar
      }
    } on InvalidAnswerFormatException {
      rethrow;
    }

    // Pindah ke pertanyaan berikutnya
    currentQuestionIndex++;

    // tandai waktu jik sudah sampai ke pertanyaan terakhir
    if (isFinished()) {
      endTime = DateTime.now();
    }

    return isCorrect;
  }

  // mendapatkan status kuis saat ini
  String getStatus() {
    return isFinished() ? STATUS_FINISHED : STATUS_RUNNING;
  }

  // mendapatkan hasil akhir
  Map<String, dynamic> getResult() {
    if (!isFinished()) {
      print("Warning: hasil diminta sebelum kuis selesai");
    }

    Duration duration = endTime?.difference(startTime) ?? Duration.zero;
    return {
      'score': score,
      'totalQuestions': questions.length,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
