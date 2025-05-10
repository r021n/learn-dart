import '../models/product.dart';
import '../mixins/discountable.dart';

// extension untuk seluruh class yang merupakan turunan dari Product
extension ProductDiscountExtension on Product {
  // method ini hanya akan berfungsi dengan baik jika 'this' (object Product)
  // juga mengimplementasikan mixin Discountable.
  // Jika tidak, memanggilnya akan error saat runtime karena method dari Discountable tidak ada.
  // kita bisa melakukan pengecekan tipe data jika diperlukan
  void applySpecialOffer(double percentage) {
    if (this is Discountable) {
      // 'this as Discountable' melakukan type cast yang aman setelah dicek
      // sehingga kita memangil method dari dicountable
      (this as Discountable).applyDiscount(percentage);
      print(
        "Penawaran spesial ${(percentage * 100).toStringAsFixed(0)}% diterapkan pada produk '${this.name}'",
      );
    } else {
      print("Produk '${this.name}' tidak mendukung diskon spesial saat ini");
    }
  }
}

// contoh lain: extension untuk mendapatkan kategori berdasarkan nama
extension ProductCategoryExtension on Product {
  String get guessedCategory {
    if (name.toLowerCase().contains('baju') ||
        name.toLowerCase().contains('celana')) {
      return 'Pakaian';
    } else if (name.toLowerCase().contains('tv') ||
        name.toLowerCase().contains('laptop')) {
      return 'Elektronik';
    } else if (name.toLowerCase().contains('roti') ||
        name.toLowerCase().contains('susu')) {
      return 'Makanan & Minuman';
    }
    return 'lain-lain';
  }
}
