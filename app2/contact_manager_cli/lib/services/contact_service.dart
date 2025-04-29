import 'dart:io';
import 'dart:convert';
import '../models/contact.dart';

class ContactService {
  // list untuk menyimpan semua objek contact di memory
  List<Contact> _contacts = [];
  // path ke file tempat data disimpan
  final String _filePath = 'data/contacts.json';

  // Constructor: langsung coba muat kontak saat service dibuat
  ContactService() {
    loadContacts();
  }

  // getter untuk mengakses data kontak dari luar class (read-only)
  List<Contact> get contacts => _contacts;

  // method untuk menambah kontak baru
  void addContact(Contact contact) {
    _contacts.add(contact);
    saveContacts(); //save kontak setiap kali ada perubahan
  }

  // method untuk menghapus kontak berdasarkan index
  bool deleteContact(int index) {
    if (index >= 0 && index < _contacts.length) {
      _contacts.removeAt(index);
      saveContacts();
      return true;
    } else {
      return false;
    }
  }

  // method untuk mencari kontak berdasarkan nama (cas insensitive)
  List<Contact> searchContacts(String query) {
    if (query.isEmpty) {
      return [];
    }
    String lowerCaseQuery = query.toLowerCase();
    return _contacts
        .where((contact) => contact.name.toLowerCase().contains(lowerCaseQuery))
        .toList();
  }

  // method untuk menyimpan daftar kontak ke file json
  void saveContacts() {
    try {
      // 1. ubah List<Contact> menjadi List<Map<String, dynamic>>
      List<Map<String, dynamic>> jsonList =
          _contacts.map((contact) => contact.toJson()).toList();

      // 2. encode List<Map> menjadi String JSON
      String jsonString = jsonEncode(jsonList);

      // 3. dapatkan object file
      final file = File(_filePath);

      // 4. pastikan direktori 'data' ada
      if (!file.parent.existsSync()) {
        file.parent.createSync(
          recursive: true,
        ); // membuat direktori jika belum ada
        print("Direktori 'data' dibuat di ${file.parent.path}");
      }

      // 5. tulis string JSON ke file
      file.writeAsStringSync(jsonString);
    } catch (e) {
      print("Error saat menyimpan kontak: $e");
    }
  }

  // method untu memuat daftar contact dari file JSON
  void loadContacts() {
    try {
      final file = File(_filePath);

      // cek file jika tidak ada
      if (!file.existsSync()) {
        print("File kontak belum ada, memulai dengan daftar kosong");
        _contacts = [];
        return;
      }

      // 1. baca isi file sebagai String
      String jsonString = file.readAsStringSync();

      // hindari error jika file kosong
      if (jsonString.isEmpty) {
        print("File kontak kosong");
        _contacts = [];
        return;
      }

      // 2. decode string JSON menjadi List<dynamic> (karena decode tidak tahu tipe spesifiknya)
      List<dynamic> jsonList = jsonDecode(jsonString);

      // 3. Ubah List<dynamic> menjadi List<Contact> menggunakan factory constructor .fromJson
      _contacts =
          jsonList
              .map(
                (jsonItem) =>
                    Contact.fromJson(jsonItem as Map<String, dynamic>),
              )
              .toList();
      print("File berhasil dimuat dari $_filePath");
    } catch (e) {
      print("Error saat memuat kontak: $e");
      print("Memulai dengan daftar kontak kosong");
      _contacts = []; // reset ke list kosong jika ada error saat load
    }
  }
}
