import 'dart:io';
import 'package:inventory_cli_app/models/product.dart';
import 'package:inventory_cli_app/services/inventory_service.dart';
import 'package:inventory_cli_app/exceptions/inventory_exceptions.dart';
// import extension method agar bisa digunakan
import 'package:inventory_cli_app/extensions/product_extensions.dart';
import 'package:inventory_cli_app/extensions/string_extensions.dart';
// import fungsi generic dari utils
import 'package:inventory_cli_app/utils/generic_utils.dart';

final inventoryService = InventoryService();

void main() {
  print("======== Aplikasi Manajemen Inventaris CLI ========");
  // contoh penggunaan string extension
  String title = "Selamat datang di aplikasi inventaris";
  print(title.toTitleCase());

  while (true) {
    print("\nMenu Utama:");
    print("1. Tambah Produk Baru");
    print("2. Lihat Semua Produk");
    print("3. Lihat Detail Produk");
    print("4. Terapkan Diskon Spesial ke Produk");
    print("5. Hapus Produk");
    print("6. Keluar");
    stdout.write("Pilih Opsi: ");
    String? choice = stdin.readLineSync()?.trimToNull();

    try {
      // bungkus switch dengan try catch untuk error umum
      switch (choice) {
        case "1":
          addProductUI();
          break;
        case "2":
          viewAllProductsUI();
          break;
        case "3":
          viewProductDetailUI();
          break;
        case "4":
          applySpecialDiscountUI();
          break;
        case "5":
          deleteProductUI();
          break;
        case "6":
          print("Menyimpan dan keluar...");
          exit(0);
        default:
          print("pilihan tidak valid");
      }
    } on InventoryException catch (e) {
      print("\nError Inventaris: $e");
    } catch (e) {
      // tangkap error tak terduga lainnya
      print("\nTerjadi Kesalahan Sistem: $e");
    }
  }
}

// Helper UI
String readInput(String prompt, {bool allowEmpty = false}) {
  String? input;
  while (true) {
    stdout.write(prompt);
    input = stdin.readLineSync();
    if (input == null || (!allowEmpty && input.trim().isEmpty)) {
      print("Input tidak boleh kosong");
    } else {
      return input.trim();
    }
  }
}

double readDoubleInput(String prompt) {
  while (true) {
    String input = readInput(prompt);
    double? value = double.tryParse(input);
    if (value != null && value > 0) {
      return value;
    } else {
      print("masukkan angka positif yang valid");
    }
  }
}

int readIntInput(String prompt, {int? min, int? max}) {
  while (true) {
    String input = readInput(prompt);
    int? value = int.tryParse(input);
    bool valid = value != null;
    if (valid && min != null) valid = value >= min;
    if (valid && max != null) valid = value! <= max;

    if (valid) {
      return value!;
    } else {
      String errorMsg = "Masukkan angka integer yang valid.";
      if (min != null && max != null)
        errorMsg += " (antara $min dan $max)";
      else if (min != null)
        errorMsg += " (minimal $min)";
      else if (min != null)
        errorMsg += " (maksimal $max)";
      print(errorMsg);
    }
  }
}

// UI Functions
void addProductUI() {
  print("\n---- Tambah Produk Baru ----");
  print("Pilih tipe produk: ");
  print("1. Elektronik ");
  print("2. Pakaian ");
  print("3. Makanan ");
  String typeChoice = readInput("Tipe (1-3): ");

  String name = readInput("Nama Produk: ");
  double basePrice = readDoubleInput("Harga Dasar: ");

  String? newProductId;

  try {
    switch (typeChoice) {
      case '1':
        String brand = readInput("Merek: ");
        int warranty = readIntInput("Masa garansi (bulan, min 0): ", min: 0);
        newProductId = inventoryService.addElectronicProduct(
          name: name,
          basePrice: basePrice,
          brand: brand,
          warrantyMonths: warranty,
        );
        break;
      case '2':
        String size = readInput("Ukuran (S/M/L/XL, dll): ");
        String material = readInput("Bahan: ");
        newProductId = inventoryService.addClothingProduct(
          name: name,
          basePrice: basePrice,
          size: size,
          material: material,
        );
        break;
      case '3':
        String ingredients = readInput("Bahan-bahan: ");
        DateTime? expiryDate;
        String expiryInput = readInput(
          "Tanggal kadaluwarsa (YYYY-MM-DD, kosongkan jika tidak ada): ",
          allowEmpty: true,
        );

        if (expiryInput.isNotEmpty) {
          try {
            expiryDate = DateTime.parse(expiryInput);
          } catch (e) {
            print("Format tanggal kadaluwarsa tidak valid");
          }
        }

        newProductId = inventoryService.addFoodProduct(
          name: name,
          basePrice: basePrice,
          ingredients: ingredients,
          expiryDate: expiryDate,
        );
        break;
      default:
        print("Tipe produk tidak valid");
        return;
    }

    if (newProductId != null) {
      print("Produk berhasil ditambahkan dengan ID: $newProductId");
    }
  } on InvalidProductDataException catch (e) {
    // tangkap exception spesifik dari service
    print("Error data: $e");
  }
}

void viewAllProductsUI() {
  List<Product> products = inventoryService.getAllProducts();
  printAllItems<Product>(products, "Daftar semua produk (Summary)");

  // penggunakan extension ProductCategoryExtension
  if (products.isNotEmpty) {
    print("\n----- Kategori (Tebakan berdasarkan nama) -----");
    products.forEach((p) => print("${p.name}: ${p.guessedCategory}"));
  }
}

void viewProductDetailUI() {
  print("\n----- Lihat Detail Produk -----");
  if (inventoryService.getAllProducts().isEmpty) {
    print("Inventaris kosong");
    return;
  }

  String id = readInput("Masukkan ID produk: ");
  Product? product = inventoryService.findProductById(id);

  if (product == null) {
    print("Produk dengan ID: $id tidak ditemukan");
  } else {
    print(product.getDetails());
  }
}

void applySpecialDiscountUI() {
  print("\n----- Terapkan diskon spesial -----");

  Product? selectedProduct = selectItemFromList<Product>(
    inventoryService.getAllProducts(),
    "Pilih produk untuk diberi diskon",
    (product) => "${product.name} ID${product.id}",
  );

  if (selectedProduct == null) {
    print("Tidak ada produk yang dipilih dan operasi dibatalkan");
    return;
  }

  double discountPercentage = readDoubleInput(
    "Masukkan persentase diskon (misal 0.1 untuk 10%): ",
  );
  if (discountPercentage < 0.0 || discountPercentage > 1.0) {
    print("Persentase diskon tidak valid (harus antara 0.0 dan 1.0)");
    return;
  }

  // gunakan extension method
  selectedProduct.applySpecialOffer(discountPercentage);
  inventoryService.saveInventory();
  print("Detail produk setelah diskon:");
  print(selectedProduct.getDetails());
}

void deleteProductUI() {
  print("\n------ Hapus Produk ------");
  Product? productToDelete = selectItemFromList<Product>(
    inventoryService.getAllProducts(),
    "Pilih produk yang akan dihapus",
    (product) => "${product.name} ID${product.id}",
  );

  if (productToDelete == null) {
    print("Tidak ada produk yang dipilih dan operasi dibatalkan");
    return;
  }

  stdout.write(
    "Anda yakin ingin menghapus '${productToDelete.name}' (ID: ${productToDelete.id})? (Y/N): ",
  );
  String confirmation = stdin.readLineSync()?.toLowerCase() ?? "n";

  if (confirmation == 'y') {
    try {
      inventoryService.deleteProduct(productToDelete.id);
      print("${productToDelete.name} berhasil dihapus");
    } on ProductNotFoundException catch (e) {
      print("Error: $e");
    }
  } else {
    print("Penghapusan dibatalkan");
  }
}
