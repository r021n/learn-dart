import 'product.dart';
import '../mixins/expirable.dart';

class FoodProduct extends Product with Expirable {
  String ingredients;

  FoodProduct({
    required String id,
    required String name,
    required double basePrice,
    required this.ingredients,
    DateTime? expiryDate, // terima expiry date opsional
  }) : super(id: id, name: name, basePrice: basePrice) {
    if (expiryDate != null) {
      setExpiryDate(expiryDate);
    }
  }

  @override
  String getDetails() {
    return '''
---- Produk Makanan ----
ID                : $id
Nama              : $name
Bahan             : $ingredients
Harga Dasar       : Rp${basePrice.toStringAsFixed(2)}
Harga Jual        : Rp${getFinalPrice().toStringAsFixed(2)}
Info Kadaluwarsa  : $expiryInfo
''';
  }

  @override
  double getFinalPrice() {
    if (isExpired) {
      print("PERHATIAN: Produk '$name' sudah kadaluwarsa!");
      return basePrice *
          0.2; // contoh diskon besar jika kadaluwarsa tapi masih dijual
    }
    return basePrice;
  }

  Map<String, dynamic> toJson() {
    final json = super.toJsonBase();
    json.addAll({
      'ingredients': ingredients,
      'expiryDate': expiryDate?.toIso8601String(),
    });

    return json;
  }

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    final product = FoodProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      ingredients: json['ingredients'] as String,
      expiryDate:
          json['expiryDate'] == null
              ? null
              : DateTime.parse(json['expiryDate'] as String),
    );
    return product;
  }
}
