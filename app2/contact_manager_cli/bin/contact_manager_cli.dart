import 'dart:io';
import 'package:contact_manager_cli/services/contact_service.dart';
import 'package:contact_manager_cli/models/contact.dart';

final contactService = ContactService();

void main() {
  print("===== Aplikasi Manajemen Kontak CLI =====");

  // looping aplikasi untuk menampilkan pilihan kepada client
  while (true) {
    print("\nMenu:");
    print("1. Tambah Kontak");
    print("2. Lihat Semua Kontak");
    print("3. Cari Kontak");
    print("4. Hapus Kontak");
    print("5. Keluar Kontak");
    stdout.write("Pilih opsi(1-5): ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addContactUI();
        break;
      case '2':
        viewContactsUI();
        break;
      case '3':
        searchContactsUI();
        break;
      case '4':
        deleteContactUI();
        break;
      case '5':
        print("Menyimpan kontak dan keluar...");
        print("Terimakasih");
        exit(0);
      default:
        print("Pilihan tidak valid, silahkan coba lagi.");
    }
  }
}

// fungsi untuk menambahkan kontak
void addContactUI() {
  print("\n----- Tambah Kontak Baru -----");
  stdout.write("Name: ");
  String name = stdin.readLineSync() ?? '';
  stdout.write("Nomor Telepon: ");
  String phone = stdin.readLineSync() ?? '';
  stdout.write("Email: ");
  String email = stdin.readLineSync() ?? "";

  // validasi nama dan nomor telepon harus ada
  if (name.isEmpty || phone.isEmpty) {
    print("Nama dan nomor telepon tidak boleh kosong");
    return;
  }

  // buat object contact baru
  var newContact = Contact(name: name, phone: phone, email: email);

  // memanggil method dari service untuk menambahkan kontak
  contactService.addContact(newContact);
  print("Kontak $name berhasil ditambahkan");
}

// fungsi untuk menampikan daftar contacts
void viewContactsUI() {
  print("\n----- Daftar Contacts -----");
  // dapatkan kontak melalui getter di service
  var contacts = contactService.contacts;

  if (contacts.isEmpty) {
    print("Kontak ini kosong");
  } else {
    for (int i = 0; i < contacts.length; i++) {
      print(
        "${i + 1}. ${contacts[i]}",
      ); // pada string interpolation ini, dart sudah secara otomatis melakukan toString(). dan karena sudah dioverride di class contact, maka method toString yang ada pada class terebutlah yang akan digunakan
    }
  }
}

void searchContactsUI() {
  print("\n----- Cari Contact -----");
  stdout.write("Masukkan nama kontak yang ingin dicari: ");
  String query = stdin.readLineSync() ?? '';

  if (query.isEmpty) {
    print("Nama pencarian tidak boleh kosong");
    return;
  }

  var results = contactService.searchContacts(query);

  if (results.isEmpty) {
    print("Tidak dapat menemukan kontak dengan nama $query");
  } else {
    print("Hasil pencarian untuk $query: ");
    for (var contact in results) {
      print("- $contact"); // secara otomatis menggunakan toString
    }
  }
}

void deleteContactUI() {
  print("\n----- Hapus Kontak -----");
  viewContactsUI();

  var contacts = contactService.contacts;
  if (contacts.isEmpty) {
    return; // keluar jika tidak ada kontak
  }

  stdout.write(
    "Masukkan nomor kontak yang ingin dihapus atau ketik 0 untuk batal: ",
  );
  String? input = stdin.readLineSync();
  int? indexToDelete = int.tryParse(input ?? '');

  if (indexToDelete == null) {
    print("Input tidak valid");
    return;
  }

  if (indexToDelete == 0) {
    print("batal untuk menghapus");
    return;
  }

  // megubah menjadi index array, karena inputan berbasis 1 sedangkan index berbasis 0
  int actualIndex = indexToDelete - 1;

  if (contactService.deleteContact(actualIndex)) {
    print("Kontak berhasil dihapus");
  } else {
    print("Nomor kontak tida valid");
  }
}
