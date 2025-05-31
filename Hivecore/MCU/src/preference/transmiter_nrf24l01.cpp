#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

RF24 radio(9, 10); // CE, CSN
const byte alamat[] = "12345";

void setup() {
  Serial.begin(9600);
  radio.begin();
  radio.openWritingPipe(alamat);
  radio.setPALevel(RF24_PA_LOW);
  radio.stopListening(); // Mode kirim
}

void loop() {
  const char teks[] = "Halo Receiver!";
  radio.write(&teks, sizeof(teks));
  Serial.println("Data terkirim: Halo Receiver!");
  delay(1000);
}