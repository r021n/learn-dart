import 'dart:io';
import 'dart:convert';
import 'dart:math'; // untuk generate ID
import '../models/product.dart';
import '../models/electronic_product.dart';
import '../models/clothing_product.dart';
import '../models/food_product.dart';
import '../exceptions/inventory_exceptions.dart';
import '../utils/generic_utils.dart'; //impor fungsi generic

class InventoryService {
  List<Product> _products = [];
  final String _filePath = 'data/inventory.json';
  int _nextIdCounter = 1;

  InventoryService() {
    loadInventory();
  }

  // ID generator
  String _generateId(String prefix) {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    return "$prefix-$timeStamp-${_nextIdCounter++}";
  }

  // Load Inventory
  void loadInventory() {
    try {
      final file = File(_filePath);
      if (!file.existsSync()) {
        _products = [];
        _nextIdCounter = 1;
        return;
      }

      String jsonString = file.readAsStringSync();
      if (jsonString.isEmpty) {
        _products = [];
        _nextIdCounter = 1;
        return;
      }

      List<dynamic> jsonList = jsonDecode(jsonString);
      _products.clear(); // bersihkan list sebelum load

      for (final itemJson in jsonList) {
        if (itemJson is! Map<String, dynamic>) {
          print(
            "WARNING: Skpping invalid item in JSON (not a Map): ${itemJson}",
          );
          continue;
        }
        final Map<String, dynamic> productMap = itemJson;
        final String? type = productMap['type'] as String?;
        Product? product;

        // Deserialisasi berdasarkan tipe
        switch (type) {
          case 'ElectronicProduct':
            product = ElectronicProduct.fromJson(productMap);
            break;
          case 'ClothingProduct':
            product = ClothingProduct.fromJson(productMap);
            break;
          case 'FoodProduct':
            product = FoodProduct.fromJson(productMap);
            break;
          default:
            print(
              "Warning: Tipe produk tidak dikenal '$type' dari JSON. dilewati",
            );
        }
        if (product != null) {
          _products.add(product);
        }
      }

      // Update ID counter
      if (_products.isNotEmpty) {
        try {
          _nextIdCounter =
              _products
                  .map((p) {
                    final parts = p.id.split('-');
                    return int.tryParse(parts.last) ?? 0;
                  })
                  .reduce(max) +
              1;
        } catch (e) {
          _nextIdCounter =
              (_products.map((p) => p.id.hashCode).reduce(max) % 10000) +
              _products.length +
              1;
        }
        if (_nextIdCounter <= 0) _nextIdCounter = 1;
      } else {
        _nextIdCounter = 1;
      }
      print(
        "Inventaris berhasil dimuat. Jumlah produk: ${_products.length}. Next ID prefix counter: $_nextIdCounter",
      );
    } on FormatException catch (e) {
      throw JsonParseException(e.message);
    } catch (e) {
      print(
        "Error saat memuat inventaris: $e. Memulai dengan inventaris kosong",
      );
      _products = [];
      _nextIdCounter = 1;
    }
  }

  // Save inventory
  void saveInventory() {
    try {
      // gunakan toJson() dari masing masing subclass Product
      List<Map<String, dynamic>> jsonList =
          _products.map((product) {
            if (product is ElectronicProduct) return product.toJson();
            if (product is ClothingProduct) return product.toJson();
            if (product is FoodProduct) return product.toJson();
            return product
                .toJsonBase(); // fallback, seharusnya tidak terjadi jika semua tipe dihandle
          }).toList();

      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String jsonString = encoder.convert(jsonList);
      final file = File(_filePath);
      if (!file.parent.existsSync()) file.parent.createSync(recursive: true);
      file.writeAsStringSync(jsonString);
    } catch (e) {
      print("error saat menyimpan inventaris: $e");
    }
  }

  // Menambah produk (Elektronik)
  String? addElectronicProduct({
    required String name,
    required double basePrice,
    required String brand,
    required int warrantyMonths,
  }) {
    if (name.trim().isEmpty ||
        basePrice <= 0 ||
        brand.trim().isEmpty ||
        warrantyMonths < 0) {
      throw InvalidProductDataException(
        "Nama, harga dasar, merek, dan garansi harus valid",
      );
    }
    final id = _generateId("ELEC");
    final product = ElectronicProduct(
      id: id,
      name: name,
      basePrice: basePrice,
      brand: brand,
      warrantyMonths: warrantyMonths,
    );
    _products.add(product);
    saveInventory();
    return id; // kembalikan ID produk baru
  }

  // Menambah produk (Makanan)
  String? addFoodProduct({
    required String name,
    required double basePrice,
    required String ingredients,
    DateTime? expiryDate,
  }) {
    if (name.trim().isEmpty || basePrice <= 0 || ingredients.trim().isEmpty) {
      throw InvalidProductDataException(
        "Nama, harga dasar, dan bahan harus valid",
      );
    }
    final id = _generateId("FOOD");
    final product = FoodProduct(
      id: id,
      name: name,
      basePrice: basePrice,
      ingredients: ingredients,
      expiryDate: expiryDate,
    );
    _products.add(product);
    saveInventory();
    return id; // kembalikan ID produk baru
  }

  // Menambah produk (Clothing)
  String? addClothingProduct({
    required String name,
    required double basePrice,
    required String size,
    required String material,
  }) {
    if (name.trim().isEmpty ||
        basePrice <= 0 ||
        size.trim().isEmpty ||
        material.trim().isEmpty) {
      throw InvalidProductDataException(
        "Nama, harga dasar, ukuran, dan bahan harus valid",
      );
    }
    final id = _generateId("CLTH");
    final product = ClothingProduct(
      id: id,
      name: name,
      basePrice: basePrice,
      size: size,
      material: material,
    );
    _products.add(product);
    saveInventory();
    return id; // kembalikan ID produk baru
  }

  // mendapatkan semua product
  List<Product> getAllProducts() {
    return List.from(_products); // kembalikan salinan
  }

  // mencari produk berdasarkan ID menggunakan fungsi generik
  Product? findProductById(String id) {
    // gunakan fungsi generik dari utils
    return findItemById<Product>(_products, id.trim());
  }

  // menghapus produk
  bool deleteProduct(String id) {
    final product = findProductById(id);
    if (product == null) throw ProductNotFoundException(id);

    _products.removeWhere((p) => p.id == id);
    saveInventory();
    return true;
  }
}
