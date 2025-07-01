#include <WiFi.h>

// Ganti dengan SSID dan password WiFi utama kamu
const char* ssid = "NamaWiFi";
const char* password = "PasswordWiFi";

// SSID dan password untuk fallback hotspot
const char* ap_ssid = "ESP32_FallbackAP";
const char* ap_password = "12345678";

unsigned long previousMillis = 0;
const long interval = 10000;  // Interval cek koneksi tiap 10 detik

const int maxReconnectAttempts = 5;  // Max coba reconnect sebelum fallback
int reconnectAttempts = 0;

enum WiFiState {
  WIFI_CONNECTING,
  WIFI_CONNECTED,
  WIFI_AP_MODE
};

WiFiState wifiState = WIFI_CONNECTING;

void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("Memulai koneksi WiFi...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
}

void startAPMode() {
  Serial.println("Gagal koneksi WiFi, masuk mode Access Point...");
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ap_ssid, ap_password);
  Serial.print("AP aktif, SSID: ");
  Serial.println(ap_ssid);
  wifiState = WIFI_AP_MODE;
}

void loop() {
  unsigned long currentMillis = millis();

  if (wifiState == WIFI_CONNECTING) {
    if (WiFi.status() == WL_CONNECTED) {
      Serial.print("Terhubung ke WiFi, IP: ");
      Serial.println(WiFi.localIP());
      wifiState = WIFI_CONNECTED;
      reconnectAttempts = 0;  // reset counter reconnect
    } else {
      if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis;
        reconnectAttempts++;
        Serial.print("Mencoba konek ke WiFi... Attempt ");
        Serial.println(reconnectAttempts);

        if (reconnectAttempts > maxReconnectAttempts) {
          startAPMode();
        }
      }
    }
  }
  else if (wifiState == WIFI_CONNECTED) {
    // Cek koneksi setiap interval, kalau terputus coba reconnect
    if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      if (WiFi.status() != WL_CONNECTED) {
        Serial.println("WiFi terputus! Mencoba reconnect...");
        wifiState = WIFI_CONNECTING;
        WiFi.disconnect();
        WiFi.begin(ssid, password);
      }
    }
  }
  else if (wifiState == WIFI_AP_MODE) {
    // Di mode AP, bisa tambahkan logika lain jika perlu
  }
}

/*
Awal masuk, ESP32 coba konek WiFi normal.
Kalau gagal lebih dari 5x (atau sesuaikan maxReconnectAttempts), masuk mode hotspot fallback.
Kalau konek sukses, cek koneksi tiap 10 detik, kalau putus otomatis coba reconnect.
Mode AP aktif dengan SSID/password fallback.
*/