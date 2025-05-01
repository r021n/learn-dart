class Weather {
  final String cityName;
  final double temperatureCelcius;
  final String description;
  final int humidity;
  final double windSpeed;

  // constructor
  Weather({
    required this.cityName,
    required this.temperatureCelcius,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  // factory constructor untuk membuat objek Weather dari JSON Map
  factory Weather.fromJson(Map<String, dynamic> json) {
    // lakukan ekstraksi data dari struktur JSON  API
    try {
      return Weather(
        cityName: json['name'] as String,
        // konversi suhu dari kelvin ke celcius
        temperatureCelcius: (json['main']['temp'] as num) - 273.15,
        description: json['weather'][0]['description'] as String,
        humidity: json['main']['humidity'] as int,
        windSpeed:
            (json['wind']['speed'] as num)
                .toDouble(), // memastikan hasilnya double
      );
    } catch (e) {
      // melempar error jika struktur json tidak sesuai harapan
      print("Error parsing json to Weather object: $e");
      print("received json: $json"); // untuk debugging
      throw FormatException("Gagal memparsing data cuaca dari API: $e");
    }
  }

  // Override toString() untuk membuat tampilan yang bagus
  @override
  String toString() {
    // format suhu menjadi 1 angka desimal
    String tempFormatted = temperatureCelcius.toStringAsFixed(1);
    return ''' 
----- Cuaca di $cityName -----
Suhu        : ${tempFormatted}°C
Kondisi     : $description
Kelembapan  : $humidity%
Angin       : ${windSpeed} m/s
    
    ''';
  }
}
