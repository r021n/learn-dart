// Abstract class dasar untuk semua produk
abstract class Product {
  final String id;
  String name; // bisa diubah jika ada fitur edit nama
  double basePrice; // harga dasar sebelum ada diskon atau markup

  Product({required this.id, required this.name, required this.basePrice});

  // abstract method untuk mendapatkan deskripsi detail produk
  String getDetails();

  // Abstract method untuk menghitung harga jual akhir
  // bisa berbeda implementasinya (misal elektronik ada biaya tambahan, makanan ada PPN)
  double getFinalPrice();

  // untuk konversi ke JSON (umum)
  Map<String, dynamic> toJsonBase() {
    return {
      'id': id,
      'name': name,
      'basePrice': basePrice,
      'type': runtimeType.toString(), // simpan tipe class untuk deserialisasi
    };
  }

  // method umum yang bisa di-override
  void displaySummary() {
    print("ID: $id, Name: $name, Harga Dasar: ${basePrice.toStringAsFixed(2)}");
  }
}
