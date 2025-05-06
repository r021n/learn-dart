import "dart:io";
import "package:todo_cli_app/models/priority.dart";
import "package:todo_cli_app/models/todo.dart";
import "package:todo_cli_app/services/todo_service.dart";

// initial service
final todoService = TodoService();

void main() {
  print("========= Aplikasi Todo List CLI =========");
  while (true) {
    print("\nMenu:");
    print("1. Tambah tugas baru");
    print("2. Lihat semua tugas (urut prioritas)");
    print("3. Lihat tugas (urut jatuh tempo)");
    print("4. Lihat tugas (urut tanggal dibuat)");
    print("5. Tandai selesai/belum selesai");
    print("6. Hapus tugas");
    print("7. Keluar");
    stdout.write("Pilih menu (1-7): ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addTodoUI();
        break;
      case '2':
        viewTodosUI(SortCriteria.priority);
        break;
      case '3':
        viewTodosUI(SortCriteria.dueDate);
        break;
      case '4':
        viewTodosUI(SortCriteria.createdAt);
        break;
      case '5':
        toggleTodoStatusUI();
        break;
      case '6':
        deleteTodoUI();
        break;
      case '7':
        print("menyimpan & keluar...");
        exit(0);
      default:
        print("Pilihan tidak valid, silahkan coba lagi");
    }
  }
}

// helper untuk membaca input non-null
String readInput(String prompt) {
  String? input;
  while (input == null || input.isEmpty) {
    stdout.write(prompt);
    input = stdin.readLineSync();
    if (input == null || input.isEmpty) print("Input tidak boleh kosong");
  }
  return input.trim();
}

String? readOptionalInput(String prompt) {
  stdout.write(prompt);
  String? input = stdin.readLineSync();
  return (input == null || input.isEmpty) ? null : input.trim();
}

void addTodoUI() {
  print("\n------ Tambah todo ------");
  String description = readInput("Deskripsi todo: ");

  // input prioritas dengan validasi
  Priority selectedPriority;
  while (true) {
    stdout.write("masukkan prioritas (low, medium, high): ");
    String? prioInput = stdin.readLineSync();
    Priority? p = stringToPriority(prioInput);
    if (p != null) {
      selectedPriority = p;
      break;
    } else {
      print("input prioritas tidak valid, coba lagi");
    }
  }

  String category = readInput("Kategori todo: ");
  DateTime? dueDate;
  String? dateInput = readOptionalInput(
    "Jatuh tempo todo (YYYY-MM-DD opsional): ",
  );
  if (dateInput != null) {
    try {
      dueDate = DateTime.parse(dateInput);
    } catch (e) {
      print("Format tanggal tidak sesuai: $e");
      dueDate = null; // reset jika format salah
    }
  }

  String? error = todoService.addTodo(
    description: description,
    priority: selectedPriority,
    category: category,
    dueDate: dueDate,
  );

  if (error != null) {
    print(error);
  }
  // pesan sukses sudah ada di service
}

// UI lihat semua tugas
void viewTodosUI(SortCriteria sortBy) {
  String sortDesc;
  switch (sortBy) {
    case SortCriteria.priority:
      sortDesc = "Prioritas (Tinggi ke rendah)";
      break;
    case SortCriteria.dueDate:
      sortDesc = "Jatuh tempo (Terdekat)";
      break;
    case SortCriteria.createdAt:
      sortDesc = "Tanggal dibuat (Tanggal terbaru)";
      break;
  }
  print("\n---- Daftar Tugas (Urut berdasarkan $sortDesc)----");

  List<Todo> todos = todoService.getTodos(sortBy: sortBy);
  if (todos.isEmpty) {
    print("Tidak ada daftar tugas");
  } else {
    for (final todo in todos) {
      print(todo.toListString()); // gunakan format ringkas
      print("-" * 40);
    }
  }
}

// UI toggle status
void toggleTodoStatusUI() {
  print("\n------ Tandai selesai/belum selesai ------");
  String id = readInput("Masukkan ID tugas: ");
  String? message = todoService.toggleTodoStatus(id);
  print(message ?? "Terjadi kesalahan internal");
}

// UI hapus todo
void deleteTodoUI() {
  print("\n------ Hapus todo ------");
  String id = readInput("Masukkan ID tugas yang ingin dihapus: ");
  String? message = todoService.deleteTodo(id);
  print(message ?? "Terjadi kesalahan internal");
}
