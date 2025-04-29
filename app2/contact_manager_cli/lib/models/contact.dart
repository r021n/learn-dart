class Contact {
  String name;
  String phone;
  String email;

  // construct untuk membuat object kontak baru
  Contact({required this.name, required this.phone, required this.email});

  // factory construct untuk membuat object Contact dari Map (JSON)
  // Berguna saat membaca data dari file
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'email': email};
  }

  //Override method toString() untuk tampilan yang lebih baik saat dicetak
  @override
  String toString() {
    return 'Name: $name, Telepon: $phone, Email: $email';
  }
}
