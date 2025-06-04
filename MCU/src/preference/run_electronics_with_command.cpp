// --- format command:
<TARGET|COMMAND|PARAMS>
<TARGET|COMMAND1|PARAMS1>; <TARGET|COMMAND2|PARAMS2>; <TARGET|COMMAND3|PARAMS3>

<REL1|SET|0|>
<REL1|SET|1|>
<REL1|set|duration=30000;mode=auto;retry=2>
<SERVO1|SET|pos=45>
<SERVO1|MOVE|pos=120;speed=50;delay=500>
<SDCARD|WRITE|file=log.txt;data=Start;append=true>
<SDCARD|READ|file=log.txt>
<LIGHT1|SET|r=255;g=100;b=50>
<AC1|AUTO|trigger=temp=28;action=ON;cooldown=10m>

#include <Servo.h>
#include <SPI.h>
#include <SD.h>

// --- Pin mapping ---
#define RELAY_PIN  5    // Relay untuk lampu
#define SERVO_PIN  6    // Servo motor

// --- Servo object ---
Servo myServo;

// --- SD Card settings ---
#define SD_CS_PIN 10    // CS pin SD Card reader

void setup() {
  Serial.begin(115200);

  pinMode(RELAY_PIN, OUTPUT);
  digitalWrite(RELAY_PIN, LOW); // Awal relay mati

  myServo.attach(SERVO_PIN);

  // Init SD card
  if (!SD.begin(SD_CS_PIN)) {
    Serial.println("SD Card failed!");
  } else {
    Serial.println("SD Card ready.");
  }

  Serial.println("System Ready!");
}

void loop() {
  if (Serial.available()) {
    String packet = Serial.readStringUntil('>');
    if (packet.startsWith("<")) {
      packet = packet.substring(1); // Buang '<'
      handlePacket(packet);
    }
  }
}

void handlePacket(String packet) {
  int idx1 = packet.indexOf('|');
  int idx2 = packet.indexOf('|', idx1 + 1);

  String device = packet.substring(0, idx1);
  String command = packet.substring(idx1 + 1, idx2);
  String params = packet.substring(idx2 + 1);

  device.trim();
  command.trim();
  params.trim();

  Serial.println("Device: " + device);
  Serial.println("Command: " + command);
  Serial.println("Params: " + params);

  if (device == "RELAY1") {
    handleRelay(command, params);
  } else if (device == "SERVO1") {
    handleServo(command, params);
  } else if (device == "SDCARD") {
    handleSDCard(command, params);
  } else {
    Serial.println("Unknown device!");
  }
}

// --- Handler untuk relay ---
void handleRelay(String command, String params) {
  if (command == "ON") {
    digitalWrite(RELAY_PIN, HIGH);
    Serial.println("Relay ON");
  } else if (command == "OFF") {
    digitalWrite(RELAY_PIN, LOW);
    Serial.println("Relay OFF");
  } else {
    Serial.println("Relay command unknown.");
  }
}

// --- Handler untuk servo ---
void handleServo(String command, String params) {
  if (command == "SET") {
    int pos = getParamValue(params, "pos").toInt();
    if (pos >= 0 && pos <= 180) {
      myServo.write(pos);
      Serial.print("Servo moved to ");
      Serial.println(pos);
    } else {
      Serial.println("Invalid servo position!");
    }
  } else {
    Serial.println("Servo command unknown.");
  }
}

// --- Handler untuk SD Card ---
void handleSDCard(String command, String params) {
  if (command == "WRITE") {
    String fileName = getParamValue(params, "file");
    String data = getParamValue(params, "data");
    File file = SD.open("/" + fileName, FILE_WRITE);
    if (file) {
      file.println(data);
      file.close();
      Serial.println("Data written to SD Card!");
    } else {
      Serial.println("Failed to open file!");
    }
  } else if (command == "READ") {
    String fileName = getParamValue(params, "file");
    File file = SD.open("/" + fileName);
    if (file) {
      Serial.println("Reading file:");
      while (file.available()) {
        Serial.write(file.read());
      }
      file.close();
    } else {
      Serial.println("Failed to open file!");
    }
  } else {
    Serial.println("SD Card command unknown.");
  }
}

// --- Helper function: ambil value dari params format key=value;key2=value2
String getParamValue(String params, String key) {
  int idx = params.indexOf(key + "=");
  if (idx == -1) return "";

  int start = idx + key.length() + 1;
  int end = params.indexOf(';', start);
  if (end == -1) end = params.length();

  return params.substring(start, end);
}