// fungsi untuk penambahan
double add(double a, double b){
  return a + b;
}

// fungsi untuk pengurangan
double substract(double a, double b){
  return a - b;
}

// fungsi untuk perkalian
double multiply(double a, double b){
  return a * b;
}

// fungsi untuk pembagian
double divide(double a, double b){
  if(b == 0){
    print("Tidak bisa membagi dengan nol");
    return double.nan;
  }

  return a / b;
}