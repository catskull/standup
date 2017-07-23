#include <Ultrasonic.h>
#include <ESP8266WiFi.h>

const char* ssid     = "ScumNet";
const char* password = "4357051756";
const char* host = "peaceful-refuge-56771.herokuapp.com";
String hoost = "peaceful-refuge-56771.herokuapp.com/";

const int httpPort = 80;

Ultrasonic ultrasonic(5, 4);

String name = "daved";
bool standing = false;
int debounce = 0;
bool led = false;

void setup() {
  WiFi.mode(WIFI_STA);
//  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");  
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

//void post(bool standing) {
//   String stat;
//   if (standing) {
//    stat = "true";
//   } else {
//    stat = "false";
//   }
//   String data = "?owner=" + name + "&standing=" + stat;
//   client.println("POST / HTTP/1.1");
//   client.println("Host: " + hoost);
//   client.println("Accept: */*");
//   client.println("Content-Type: application/x-www-form-urlencoded");
//   client.print("Content-Length: ");
//   client.println(data.length());
//   client.println();
//   client.print(data);
//}

void loop() {
  WiFiClient client;
  const int httpPort = 80;
  if (!client.connect(host, httpPort)) {
    Serial.println("connection failed");
    return;
  }
  
  int height = ultrasonic.distanceRead(INC);
//  Serial.println(height);
  
  if (standing && height < 50) {
    ++debounce;
  } else if (!standing && height >= 50) {
    ++debounce;
  } else {
    debounce = 0;
  }

  if (debounce > 10) {
    standing = !standing;

    String url = "/";
    url += "?owner=";
    url += name;
    url += "&standing=";
        
    if (standing) {
      Serial.println("You are now standing " + name);
      url += "true";
    } else {
      Serial.println("You are now sitting " + name);
      url += "false";
    }
    
    client.print(String("POST ") + url + " HTTP/1.1\r\n" +
      "Host: " + host + "\r\n" + 
      "Connection: close\r\n\r\n");

      unsigned long timeout = millis();
      while (client.available() == 0) {
        if (millis() - timeout > 5000) {
          Serial.println(">>> Client Timeout !");
          client.stop();
          return;
        }
      }
      
      // Read all the lines of the reply from server and print them to Serial
      while(client.available()){
        String line = client.readStringUntil('\r');
        Serial.print(line);
      }
    
    debounce = 0;
  }

  
  delay(500);
}
