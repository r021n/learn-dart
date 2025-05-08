import 'dart:io';
import 'question.dart';
import '../exceptions/quiz_exceptions.dart';

// subclass untuk pertanyaan benar/salah
class TrueFalseQuestion extends Question {
  final bool correctAnswer; // jawaban benar (true atau false)

  // constructor
  TrueFalseQuestion({
    required String id,
    required String text,
    required this.correctAnswer,
  }) : super(id: id, text: text);

  @override
  void display() {
    print("\n-------- Pertanyaan Benar/Salah --------");
    print("ID: $id");
    print("Pertanyaan: $text");
    stdout.write("Jawaban anda (Benar/Salah atau B/S atau T/F): ");
  }

  @override
  bool checkAnswer(String userAnswer) {
    String lowerAnswer = userAnswer.trim().toLowerCase();
    bool? parsedAnswer;

    if (lowerAnswer == 'benar' ||
        lowerAnswer == 'b' ||
        lowerAnswer == 't' ||
        lowerAnswer == 'true') {
      parsedAnswer = true;
    } else if (lowerAnswer == 'salah' ||
        lowerAnswer == 's' ||
        lowerAnswer == 'f' ||
        lowerAnswer == 'false') {
      parsedAnswer = false;
    }

    if (parsedAnswer == null) {
      throw InvalidAnswerFormatException(
        "Masukkan (Benar/B/T/True) untuk benar dan (Salah/S/F/False) untuk salah",
      );
    }

    return parsedAnswer == correctAnswer;
  }
}
