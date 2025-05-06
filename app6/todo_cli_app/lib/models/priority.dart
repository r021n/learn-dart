enum Priority { low, medium, high }

// helper function (opsional) untuk mendapatkan representasi string yang lebih baik
String priorityToString(Priority p) {
  switch (p) {
    case Priority.low:
      return "Rendah";
    case Priority.medium:
      return 'Sedang';
    case Priority.high:
      return 'Tinggi';
    default:
      return 'Tidak Diketahui';
  }
}

// Helper function untuk mengonversi string kembali ke Priority (case insensitive)
Priority? stringToPriority(String? s) {
  if (s == null) return null;
  switch (s.toLowerCase()) {
    case 'rendah':
    case 'low':
      return Priority.low;
    case 'sedang':
    case 'medium':
      return Priority.medium;
    case 'tinggi':
    case 'high':
      return Priority.high;
    default:
      return null;
  }
}
