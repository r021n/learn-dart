import 'dart:io';
import 'dart:convert';
import 'dart:math'; // untuk id generator sederhana
import '../models/todo.dart';
import '../models/priority.dart';

enum SortCriteria {
  priority, // Tinggi ke rendah
  dueDate, // terdekat dulu (null di akhir)
  createdAt, // terbaru duli
}

class TodoService {
  List<Todo> _todos = [];
  final String _filePath = "data/todos.json";
  int _nextIdCounter = 1; // Counter ID sederhana

  // Constructor
  TodoService() {
    loadTodos();
  }

  // ID generator sederhana
  String _generatedId() {
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final id = "$timeStamp-${_nextIdCounter++}";
    return id;
  }

  // Load & Save
  void loadTodos() {
    try {
      final file = File(_filePath);
      if (!file.existsSync()) {
        _todos = [];
        _nextIdCounter = 1;
        return;
      }

      String jsonString = file.readAsStringSync();
      if (jsonString.isEmpty) {
        _todos = [];
        _nextIdCounter = 1;
        return;
      }

      List<dynamic> jsonList = jsonDecode(jsonString);
      _todos =
          jsonList
              .map((json) => Todo.fromJson(json as Map<String, dynamic>))
              .toList();

      // update ID counter berdasarkan ID yang ada
      if (_todos.isNotEmpty) {
        try {
          _nextIdCounter =
              _todos
                  .map((todo) {
                    final parts = todo.id.split("-");
                    return int.tryParse(parts.last) ?? 0;
                  })
                  .reduce(max) +
              1;
        } catch (e) {
          print("Warning: gagal parse ID counter dari file. Resetting.");
          _nextIdCounter =
              (_todos.map((t) => t.id.hashCode).reduce(max) % 10000) +
              _todos.length +
              1;
        }
        if (_nextIdCounter <= 0) _nextIdCounter = 1;
      } else {
        _nextIdCounter = 1;
      }
      print("Daftar tugas berhasil dimuat, Next ID: $_nextIdCounter");
    } catch (e) {
      print("Error saat memuat tugas: $e");
      _todos = [];
      _nextIdCounter = 1;
    }
  }

  void saveTodos() {
    try {
      List<Map<String, dynamic>> jsonList =
          _todos.map((todo) => todo.toJson()).toList();
      // gunakan json encoder dengan indentasi untuk pretty print (opsional)
      JsonEncoder encoder = const JsonEncoder.withIndent("  ");
      String jsonString = encoder.convert(jsonList);

      final file = File(_filePath);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      file.writeAsStringSync(jsonString);
    } catch (e) {
      print("error saat menyimpan tugas: $e");
    }
  }

  // ------ Operasi CRUD ------

  // menambah tugas baru
  String? addTodo({
    required String description,
    required Priority priority,
    required String category,
    DateTime? dueDate,
  }) {
    if (description.trim().isEmpty || category.trim().isEmpty) {
      return "Deskripsi dan kategori tidak boleh kosong";
    }
    final newTodo = Todo(
      id: _generatedId(),
      description: description.trim(),
      priority: priority,
      category: category.trim(),
      createdAt: DateTime.now(),
      dueDate: dueDate,
    );
    _todos.add(newTodo);
    saveTodos();
    print("Tugas baru ditambahkan (ID: ${newTodo.id})");
    return null; // success
  }

  // mendapatkan semua tugas dengan sorting
  List<Todo> getTodos({SortCriteria sortBy = SortCriteria.priority}) {
    List<Todo> sortedTodos = List.from(_todos);

    // fungsi pembanding berdasarkan kriteria
    int Function(Todo, Todo) compareFunction;

    switch (sortBy) {
      case SortCriteria.dueDate:
        compareFunction = (a, b) {
          // prioritaskan yang punya dueDate
          if (a.dueDate == null && b.dueDate == null)
            return 0; // keduanya null, sama
          if (a.dueDate == null)
            return 1; // a null (taruh di akhir), b tidak null
          if (b.dueDate == null)
            return -1; // b null (taruh di akhir), a tidak null
          return a.dueDate!.compareTo(
            b.dueDate!,
          ); // jika keduanya tidak null, bandingkan yang terdekat dulu
        };
        break;
      case SortCriteria.createdAt:
        // terbaru dulu (descending)
        compareFunction = (a, b) => b.createdAt.compareTo(a.createdAt);
        break;
      case SortCriteria.priority: // default
      default:
        // prioritas tinggi dulu (descending), jika sama, terbaru dulu
        compareFunction = (a, b) {
          int priorityComparison = b.priority.index.compareTo(a.priority.index);
          // .index dari enum: low=0, medium=1, high=2. Jadi b.compareTo(a) -> high dulu
          if (priorityComparison != 0) {
            return priorityComparison;
          } else {
            // jika prioritas sama, urutkan berdasarkan tanggal dibuat (terbaru dulu)
            return b.createdAt.compareTo(a.createdAt);
          }
        };
        break;
    }
    sortedTodos.sort(compareFunction);
    return sortedTodos;
  }

  // mencari tugas berdasarkan ID
  Todo? findTodoById(String id) {
    id = id.trim();
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null; // tidak ditemukan
    }
  }

  // mengubah status selesai/belum selesai
  String? toggleTodoStatus(String id) {
    // tipe data kembalian dibuat opsional karena error string terkadan harus dilaporkan sebagai error. dan terkadang ketika fungsi berhasil berjalan maka akan mengembalikan null
    Todo? todo = findTodoById(id);
    if (todo == null) {
      return "Error: Todo dengan ID: $id tidak ditemukan";
    }

    todo.toggleDone(); // panggil method di model
    saveTodos();
    String status = todo.isDone ? "selesai" : "Belum Selesai";
    return "Tugas '$id' ditandai sebagai $status";
  }

  // menghapus tugas
  String? deleteTodo(String id) {
    final initialLength = _todos.length;
    _todos.removeWhere((todo) => todo.id == id);
    if (_todos.length < initialLength) {
      saveTodos();
      return "Tugas dengan ID: $id berhasil dihapus";
    } else {
      return "Error: tugas dengan ID: $id tidak ditemukan";
    }
  }
}
