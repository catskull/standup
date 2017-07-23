#include <Ultrasonic.h>

Ultrasonic ultrasonic(5, 4);

String name = "daved";
bool standing = false;
int debounce = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int height = ultrasonic.distanceRead(INC);
  Serial.println(height);
  
  if (standing && height < 50) {
    ++debounce;
  } else if (!standing && height >= 50) {
    ++debounce;
  } else {
    debounce = 0;
  }

  if (debounce > 10) {
    standing = !standing;

    if (standing) {
      Serial.println("You are now standing " + name);
    } else {
      Serial.println("You are now sitting " + name);
    }
    
    debounce = 0;
  }

  
  delay(500);
}
