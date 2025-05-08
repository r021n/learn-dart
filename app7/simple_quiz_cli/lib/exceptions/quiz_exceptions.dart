// exceptions dasar untuk masalah terkait quiz
class QuizException implements Exception {
  final String message;
  QuizException(this.message);

  @override
  String toString() => 'QuizException: $message';
}

// exceptions spesifik untuk error saat loading data kuis
class QuizLoadException extends QuizException {
  QuizLoadException(String message) : super('Gagal memuat kuis: $message');
}

// exception spesifik untuk format jawaban yang tidak valid
class InvalidAnswerFormatException extends QuizException {
  InvalidAnswerFormatException(String message)
    : super('Format jawaban tidak valid: $message');
}

// exception jika mencoba mengambil pertanyaan saat quiz sudah selesai
class NoMoreQuestionsException extends QuizException {
  NoMoreQuestionsException()
    : super('Tidak ada pertanyaan lagi dalam quiz ini');
}
