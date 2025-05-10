mixin Expirable {
  DateTime? _expiryDate; // tanggal kadaluwarsa, nullable

  void setExpiryDate(DateTime date) {
    _expiryDate = date;
  }

  DateTime? get expiryDate => _expiryDate;

  bool get isExpired {
    if (_expiryDate == null) {
      return false; // jika tidak ada tanggal kadaluwarsa, anggap tidak kadaluwarsa}
    }

    return DateTime.now().isAfter(
      _expiryDate!,
    ); // diberi tanda ! karena sudah dicek nullable nya di if di atas
  }

  String get expiryInfo {
    if (_expiryDate == null) return "Tidak ada tanggal kadaluwarsa";
    String dateStr =
        "${expiryDate!.day}/${expiryDate!.month}/${expiryDate!.year}";
    return isExpired
        ? "SUDAH KADALUWARSA (sejak: $dateStr)"
        : "Kadaluwarsa pada: $dateStr";
  }
}
