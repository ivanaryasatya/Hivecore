#include <WiFi.h>
#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

// Define the WiFi credentials
#define WIFI_SSID "YOUR_WIFI_SSID"
#define WIFI_PASSWORD "YOUR_WIFI_PASSWORD"

// Define the Firebase project credentials
#define API_KEY "YOUR_FIREBASE_API_KEY"
#define DATABASE_URL "YOUR_DATABASE_URL"

// Define the user Email and password that are already registered or added in your project
#define USER_EMAIL "YOUR_USER_EMAIL"
#define USER_PASSWORD "YOUR_USER_PASSWORD"

// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

void setup() {
    Serial.begin(115200);

    // Connect to WiFi
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    config.api_key = API_KEY;
    config.database_url = DATABASE_URL;

    // Assign user login credentials
    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    // Initialize Firebase
    Firebase.begin(&config, &auth);

    // Ensure that Firebase is successfully initialized
    if (!Firebase.ready()) {
        Serial.println("Failed to initialize Firebase");
        return;
    }

    // Retrieve data from Firebase
    if (Firebase.RTDB.getString(&fbdo, "/path/to/your/data")) {
        if (fbdo.dataType() == "string") {
            Serial.println(fbdo.stringData());
        }
    } else {
        Serial.println(fbdo.errorReason());
    }
}

void loop() {
}

