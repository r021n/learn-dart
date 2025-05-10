class InventoryException implements Exception {
  final String message;
  InventoryException(this.message);
  @override
  String toString() => "InventoryException: $message";
}

class ProductNotFoundException extends InventoryException {
  ProductNotFoundException(String productId)
    : super("Produk dengan ID $productId tidak ditemukan");
}

class InvalidProductDataException extends InventoryException {
  InvalidProductDataException(String message)
    : super("Data produk tidak valid $message");
}

class JsonParseException extends InventoryException {
  JsonParseException(String message)
    : super("Gagal mem-parsing JSON: $message");
}
