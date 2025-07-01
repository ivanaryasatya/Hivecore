#include <SD.h>
#include <SPI.h>

const int chipSelect = 53; // Untuk Arduino Mega, biasanya pin CS SD card di pin 53

void setup() {
  Serial.begin(9600);
  while (!Serial);

  if (!SD.begin(chipSelect)) {
    Serial.println("Gagal inisialisasi SD card.");
    return;
  }

  // Panggil fungsi utama: nama file & isi yang mau ditulis
  readWriteSD("data_log.csv", "Timestamp,X,Y,Z,PGA");
}

void loop() {
  // Loop kosong
}

// =============== FUNGSI UTAMA ===============
void readWriteSD(const char* filename, const String& dataToWrite) {
  // Tulis data ke file
  File file = SD.open(filename, FILE_WRITE);
  if (file) {
    file.println(dataToWrite);
    file.close();
    Serial.println("Data berhasil ditulis ke SD card.");
  } else {
    Serial.println("Gagal membuka file untuk ditulis.");
    return;
  }

  // Baca isi file
  file = SD.open(filename);
  if (file) {
    Serial.println("Isi file:");
    while (file.available()) {
      Serial.write(file.read());
    }
    file.close();
  } else {
    Serial.println("Gagal membuka file untuk dibaca.");
  }
}