// mixin untuk menambahkan fungsionalitas diskon
mixin Discountable {
  double _originalPrice = 0.0; // variable ini akan 'dicampurkan' ke class
  double _discountPercentage = 0.0; // persentase diskon (0.0 - 1.0)

  // method yang akan ada di class yang menggunakan mixin ini
  void setOriginalPrice(double price) {
    if (price < 0) throw ArgumentError("Harga tidak boleh negatif");
    _originalPrice = price;
  }

  double get originalPrice => _originalPrice;

  void applyDiscount(double percentage) {
    if (percentage < 0.0 || percentage > 1.0) {
      throw ArgumentError("Persentase diskon harus diantara 0.0 hingga 1.0");
    }
    _discountPercentage = percentage;
  }

  double get discountPercentage => _discountPercentage;

  double get priceAfterDiscount {
    return _originalPrice * (1 - _discountPercentage);
  }

  // method ini bisa mengasumsikan adanya properti 'name' di class yang menggunakannya
  // Jika tidak ada, akan error saat runtime
  // Oleh karena itu, baiknya mixin digunakan pada class yang kita tahu punya properti ini
  // atau gunakan 'on' clause jika mixin punya dependensi kuat ke tipe tertentu
  // String get discountedProductName => 'PROMO: $name (Diskon ${(_discountPercentage * 100).toStringAsFixed(0)%})'
  // untuk contoh ini, kita tidak pakai 'name' agar lebih general
  String get discountInfo =>
      "Diskon ${(_discountPercentage * 100).toStringAsFixed(0)}%. Harga asli: Rp$_originalPrice, harga setelah diskon: Rp${priceAfterDiscount.toStringAsFixed(2)}";
}
