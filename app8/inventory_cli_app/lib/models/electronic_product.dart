import 'product.dart';
import '../mixins/discountable.dart';

// produk elektronik menggunakan mixin discountable
class ElectronicProduct extends Product with Discountable {
  String brand;
  int warrantyMonths; // garansi dalam bulan

  ElectronicProduct({
    required String id,
    required String name,
    required double basePrice,
    required this.brand,
    required this.warrantyMonths,
  }) : super(id: id, name: name, basePrice: basePrice) {
    // inisialisasi harga asli untuk mixin discountable
    setOriginalPrice(basePrice);
  }

  @override
  String getDetails() {
    String discountDetails = discountPercentage > 0 ? "\n$discountInfo" : "";
    return '''
------- Produk Elektronik -------
ID          : $id
Nama        : $name
Merek       : $brand
Harga Dasar : Rp${basePrice.toStringAsFixed(2)}
Garansi     : $warrantyMonths bulan
Harga Jual  : Rp${getFinalPrice().toStringAsFixed(2)} $discountDetails
''';
  }

  @override
  double getFinalPrice() {
    // elektronik mungkin punya markup atau biaya tambahan, lalu diskon diterapkan
    // double priceWithMarkup = originalPrice * 1.1; // contoh markup 10%
    // harga setelah diskon dihitung oleh mixin Discountable dari originalPrice
    // Untuk contoh ini, diskon dari basePrice (originalPrice dari mixin)
    // Jadi, final price adalah harga diskon DARI HARGA ASLI (basePrice)
    // Jika ada markup, markup diterapkan ke harga setelah diskon
    // atau, jika diskon dari harga markup, setOriginalPrice(harga_markup) lalu panggil priceAfterDiscount
    // Pilihan desain: di sini kita asumsikan diskon berlaku pada harga dasar,
    // dan final price adalah harga setelah diskon.
    // Jika ada markup, logikanya jadi: (basePrice * (1-discount)) * markup_elektronik
    // atau (basePrice * markup_elektronik) * (1-discount)
    // Untuk simpel: kita anggap finalPrice adalah priceAfterDiscount dari mixin
    return priceAfterDiscount;
  }

  // untuk konversi ke JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJsonBase(); // panggil base
    json.addAll({
      'brand': brand,
      'warrantyMonths': warrantyMonths,
      'originalPrice': originalPrice, // dari discountable
      'discountPercentage': discountPercentage, // dari discountable
    });
    return json;
  }

  // factory dari JSON
  factory ElectronicProduct.fromJson(Map<String, dynamic> json) {
    final product = ElectronicProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      brand: json['brand'] as String,
      warrantyMonths: json['warrantyMonths'] as int,
    );

    //set state dari mixin
    product.setOriginalPrice(
      (json['originalPrice'] as num? ?? product.basePrice).toDouble(),
    );
    product.applyDiscount(
      (json['discountPercentage'] as num? ?? 0.0).toDouble(),
    );

    return product;
  }
}
