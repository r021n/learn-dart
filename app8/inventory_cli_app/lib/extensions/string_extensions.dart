// extension method untuk class String bawaan
extension StringCasingExtension on String {
  String toTitleCase() {
    if (this.isEmpty) return "";
    if (this.length == 1) return this.toUpperCase();

    // Pisahkan string berdasarkan spasi, kapitalisasi kata pertama, gabungkan lagi
    final List<String> words = this.split(' ');
    final capitalizeWord = words.map((word) {
      if (word.trim().isEmpty) return "";
      final String firstLetter = word.substring(0, 1).toUpperCase();
      final String remainingLetters = word.substring(1).toLowerCase();
      return "$firstLetter$remainingLetters";
    });
    return capitalizeWord.join(' ');
  }

  String? trimToNull() {
    final trimmed = this.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
