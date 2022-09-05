#include <SPI.h>
#include <RTClib.h>
#include <SD.h>
#include <CapacitiveSensor.h>

CapacitiveSensor cs_4_2 = CapacitiveSensor(4,2); 

String filename = "LOGS.csv";
RTC_DS3231 rtc;
File file;

void setup() {
  // Serial connection
  Serial.begin(9600);
  randomSeed(analogRead(A0));

  pinMode(10, OUTPUT); 

  // Setting RTC
  if (!rtc.begin()) {
    Serial.println(F("Couldn't find RTC"));
    while(true);
  }
  rtc.adjust(DateTime(F(__DATE__), F(__TIME__)));

  // Setting datalogger
  if (!SD.begin(10)) {
    Serial.println("Error : Push the reset button");
    for (;;); 
  }

  Serial.print("Enter file name");
  while (Serial.available()==0);
  filename = Serial.readStringUntil('\n');
  filename += ".csv";
  
  Serial.println();
  Serial.println(filename + " created");

  file = SD.open(filename, FILE_WRITE);

  // Header values
  if (file.size() == 0) {
    file.println("time, sensor_val");
    file.flush();
  }

  // Initialise capacitive sensor
  // Turning off auto calibration
  cs_4_2.set_CS_AutocaL_Millis(0xFFFFFFFF);    
}

void loop() {
  long total1 =  cs_4_2.capacitiveSensor(30);
  delay(1000);

  DateTime now = rtc.now();

  String data = String(now.hour()) + ":" + String(now.minute())  + ":" + String(now.second()) + ", " + String(total1);
  Serial.println(data);
  file.println(data);
  file.flush();
}
