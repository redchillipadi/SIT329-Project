// Use the CapacitiveSensor library from Paul Stoffregen
#include "CapacitiveSensor.h"

// Create a sensor. The parameters are
// the send and receive pins respectively, connected to each side of the 10MOhm resistor.
// The send pin might be able to be shared between mutliple sensors, as long as 
// the tinfoil to be sensed is connnected on the side of the latter pin (3 in this example)
CapacitiveSensor sensor = CapacitiveSensor(2, 3);

// Setup - just get the serial port working for debugging
void setup() {
  Serial.begin(9600);
}

// Read the sensor every second and print the value
void loop() {
  long value = sensor.capacitiveSensor(50);
  Serial.println(value);

  delay(1000);
}
