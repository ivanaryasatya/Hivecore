#include <SdFat.h>

SdFat SD;
SdVolume volume;
Sd2Card card;

const int chipSelect = 10;
const unsigned long MIN_FREE_SPACE = 100000; // 100 KB

void setup() {
  Serial.begin(9600);
  if (!SD.begin(chipSelect)) {
    Serial.println("SD card gagal diinisialisasi.");
    return;
  }

  // Panggil fungsi auto-delete (true = aktif)
  checkAndDeleteOldestLogIfNeeded(true);
}

void loop() {
  // Program utama kamu
}

// ============ FUNGSI UTAMA ===============
void checkAndDeleteOldestLogIfNeeded(bool autoDeleteEnabled) {
  if (!autoDeleteEnabled) {
    Serial.println("Auto delete tidak aktif.");
    return;
  }

  // Inisialisasi SD card dan volume
  if (!card.init(SPI_HALF_SPEED, chipSelect)) {
    Serial.println("Gagal inisialisasi kartu.");
    return;
  }
  if (!volume.init(card)) {
    Serial.println("Gagal inisialisasi volume.");
    return;
  }

  uint32_t freeClusters = volume.freeClusterCount();
  uint32_t clusterSize = volume.blocksPerCluster() * 512UL;
  uint32_t freeSpace = freeClusters * clusterSize;

  Serial.print("Sisa ruang SD card: ");
  Serial.print(freeSpace / 1024);
  Serial.println(" KB");

  if (freeSpace >= MIN_FREE_SPACE) {
    Serial.println("Ruang masih cukup.");
    return;
  }

  Serial.println("Ruang hampir penuh. Mencari file tertua...");

  SdFile root;
  root.open("/");
  SdFile entry;

  char oldestFile[32] = "";
  char name[32];
  String oldestDate = "";

  while (entry.openNext(&root, O_RDONLY)) {
    entry.getName(name, sizeof(name));
    String fileName = String(name);
    if (!entry.isDir() && fileName.endsWith(".csv")) {
      int us1 = fileName.indexOf('_');
      int us2 = fileName.indexOf('_', us1 + 1);
      int dot = fileName.lastIndexOf('.');
      if (us2 != -1 && dot > us2) {
        String dateStr = fileName.substring(us2 + 1, dot);
        if (oldestDate == "" || dateStr < oldestDate) {
          oldestDate = dateStr;
          fileName.toCharArray(oldestFile, sizeof(oldestFile));
        }
      }
    }
    entry.close();
  }

  root.close();

  if (strlen(oldestFile) > 0) {
    Serial.print("Menghapus file: ");
    Serial.println(oldestFile);
    SD.remove(oldestFile);
  } else {
    Serial.println("Tidak ditemukan file .csv yang valid.");
  }
}