import 'product.dart';
import '../mixins/discountable.dart';

class ClothingProduct extends Product with Discountable {
  String size;
  String material;

  ClothingProduct({
    required String id,
    required String name,
    required double basePrice,
    required this.size,
    required this.material,
  }) : super(id: id, name: name, basePrice: basePrice) {
    setOriginalPrice(basePrice);
  }

  @override
  String getDetails() {
    String discountDetails = discountPercentage > 0 ? "\n$discountInfo" : "";
    return '''
---- Produk Pakaian ----
ID          : $id
Nama        : $name
Ukuran      : $size
Bahan       : $material
Harga Dasar : Rp${basePrice.toStringAsFixed(2)}
Harga Jual  : Rp${getFinalPrice().toStringAsFixed(2)} $discountDetails
''';
  }

  @override
  double getFinalPrice() {
    // pakaian mungkin tidak ada markup, hana diskon saja
    return priceAfterDiscount; // dari mixin discountable
  }

  Map<String, dynamic> toJson() {
    final json = super.toJsonBase();
    json.addAll({
      'size': size,
      'material': material,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
    });

    return json;
  }

  factory ClothingProduct.fromJson(Map<String, dynamic> json) {
    final product = ClothingProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      size: json['size'] as String,
      material: json['material'] as String,
    );

    product.setOriginalPrice(
      (json['originalPrice'] as num? ?? product.basePrice).toDouble(),
    );
    product.applyDiscount(
      (json['discountPercentage'] as num? ?? 0.0).toDouble(),
    );

    return product;
  }
}
