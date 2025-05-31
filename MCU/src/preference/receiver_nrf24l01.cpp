#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(9, 10); // CE, CSN
const byte alamat[] = "12345";

void setup() {
  Serial.begin(9600);
  radio.begin();
  radio.openReadingPipe(0, alamat);
  radio.setPALevel(RF24_PA_LOW);
  radio.startListening(); // Mode terima
}

void loop() {
  if (radio.available()) {
    char teks[32] = "";
    radio.read(&teks, sizeof(teks));
    Serial.print("Data diterima: ");
    Serial.println(teks);
  }
}