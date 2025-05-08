// service untuk membaca file JSON dan membuat list Question
import 'dart:io';
import 'dart:convert';
import '../models/question.dart';
import '../models/multiple_choice_question.dart';
import '../models/true_false_question.dart';
import '../exceptions/quiz_exceptions.dart'; // import custom exception

class QuizLoader {
  List<Question> loadQuestionsFromFile(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        throw QuizLoadException("File tidak ditemukan di: $filePath");
      }

      final jsonString = file.readAsStringSync();
      if (jsonString.isEmpty) {
        throw QuizLoadException("File kuis $filePath kosong");
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      if (jsonList.isEmpty) {
        throw QuizLoadException(
          "Tidak ada pertanyaan yang ditemukan dalam file",
        );
      }

      List<Question> questions = [];
      for (final item in jsonList) {
        if (item is! Map<String, dynamic>) {
          print("Warning: skipping invalid item in JSON (not a map): $item");
          continue; // lewati item yang bukan map
        }

        final Map<String, dynamic> questionJson = item;

        // dapatkan tipe pertanyaan dari json
        final String? type = questionJson['type'] as String?;
        final String id =
            questionJson['id'] as String? ??
            DateTime.now().microsecondsSinceEpoch
                .toString(); // default ID jika null
        final String text =
            questionJson['text'] as String? ?? "Pertanyaan tidak valid";

        Question? question;

        // buat instance class yang sesuai berdasarkan 'type'
        switch (type) {
          case 'multiple_choice':
            final List<dynamic>? optionsDyn =
                questionJson["options"] as List<dynamic>?;
            final List<String> options =
                optionsDyn?.map((e) => e.toString()).toList() ?? [];
            final int? correctIndex =
                questionJson['correctOptionIndex'] as int?;

            if (options.isNotEmpty &&
                correctIndex != null &&
                correctIndex >= 0 &&
                correctIndex < options.length) {
              question = MultipleChoiceQuestion(
                id: id,
                text: text,
                options: options,
                correctOptionIndex: correctIndex,
              );
            } else {
              print(
                "Warning: Skipping invalid multiple choice question (ID: $id) due to missing/invalid options or correct index.",
              );
            }
            break;
          case 'true_false':
            final bool? correctAnswer = questionJson['correctAnswer'] as bool?;
            if (correctAnswer != null) {
              question = TrueFalseQuestion(
                id: id,
                text: text,
                correctAnswer: correctAnswer,
              );
            } else {
              print(
                "Warning: skipping invalid true/false question (ID: $id) due to missing correct answer",
              );
            }
            break;
          default:
            print(
              "Warning: tipe pertanyaan tidak dikenal '$type' (ID: $id). dilewati",
            );
        }
        if (question != null) {
          questions.add(question);
        }
      }

      if (questions.isEmpty) {
        throw QuizLoadException(
          "Tidak ada pertanyaan valid yang berhasil dimuat dari file",
        );
      }

      print("Berhasil memuat ${questions.length} pertanyaan dari $filePath");
      return questions;
    } on FormatException catch (e) {
      throw QuizLoadException("Format JSON tidak valid: ${e.message}");
    } on QuizLoadException {
      rethrow;
    } catch (e) {
      throw QuizLoadException("Terjadi kesalahan tak terduga saat memuat: $e");
    }
  }
}
