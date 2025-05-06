import 'priority.dart';

class Todo {
  final String id;
  String description;
  Priority priority;
  String category;
  bool isDone;
  final DateTime createdAt;
  DateTime? dueDate;

  // constructor
  Todo({
    required this.id,
    required this.description,
    this.priority = Priority.medium, // default priority
    required this.category,
    this.isDone = false, // default belum selesai
    required this.createdAt,
    this.dueDate,
  });

  // Factory constructor dari JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    try {
      return Todo(
        id: json['id'] as String,
        description: json['description'] as String,
        // konversi string prioritas dari JSON ke enum priority
        // gunakan .name untuk mendapatkan nama string enum (low, medium, high)
        // gunakan enum.values.byName() untuk mencari enum berdasarkan namanya
        priority: Priority.values.byName(
          json['priority' as String? ?? 'medium'],
        ),
        category: json['category'] as String? ?? 'umum', // default jika null
        isDone: json['isDone'] as bool? ?? false, // default jika null
        createdAt: DateTime.parse(json['dateTime'] as String),
        dueDate:
            json['dueDate'] == null
                ? null
                : DateTime.parse(json['dueDate' as String]),
      );
    } catch (e) {
      print('Error parsing json to Todo object: $e');
      print('received json: $json');
      throw FormatException('Gagal memparsing data todo dari JSON: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      // simpan nama string dari enum ke JSON (e.g., 'high')
      'priority': priority.name,
      'category': category,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(), // handle null
    };
  }

  // method untuk mengubah status selesai
  void toggleDone() {
    isDone = !isDone;
  }

  // representasi string untuk daftar
  String toListString() {
    String status = isDone ? '[✔]' : '[]';
    String priorityStr = priorityToString(priority).padRight(6);
    String dueDateStr =
        dueDate != null
            ? "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}"
            : "Tanpa batas";
    return "$status ID: $id | prioritas: $priorityStr | kategori: $category | jatuh tempo: $dueDateStr \n deskripsi: $description";
    // tambahkan baris baru untuk deskrpsi supaya lebih rapi
  }

  // representasi string detail (bisa sama dengan toListString atau lebih detail)
  @override
  String toString() {
    String status = isDone ? "Selesai" : "Belum Selesai";
    String priorityStr = priorityToString(priority);
    String createdDateStr =
        "${createdAt.day}/${createdAt.month}/${createdAt.year}";
    String dueDateStr =
        dueDate != null
            ? "${dueDate!.day}/${dueDate!.month}/${dueDate!.year}"
            : "Tidak ada";

    return '''
--- Detail Tugas (ID: $id) ---
Deskripsi   : $description
Status      : $status
Prioritas   : $priorityStr
Kategori    : $category
Dibuat tgl  : $createdDateStr
Jatuh tempo : $dueDateStr
------------------------------
''';
  }
}
