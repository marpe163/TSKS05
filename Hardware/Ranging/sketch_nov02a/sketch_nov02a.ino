#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

#define NUM_ANCHORS 4
uint8_t num_anchors = NUM_ANCHORS;
uint16_t anchors[NUM_ANCHORS] = {0x6078, 0x603F, 0x6050, 0x6000};

char buf[128];

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  if (Pozyx.begin() == POZYX_FAILURE) {
    Serial.println(F("ERROR: Unable to connect to POZYX shield"));
    Serial.println(F("Reset required"));
    delay(100);
    abort();
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  static uint32_t count = 1;
  Serial.print(count);
  for (int i = 0; i < num_anchors; i++) {
    device_range_t range;
    Pozyx.doRanging(anchors[i], &range); // THIS IS FOR MORE THAN 4 ANCHORS
    Pozyx.getDeviceRangeInfo(anchors[i], &range);
    sprintf(buf, " 0x%x: %umm, %idB", anchors[i], range.distance, range.RSS);
//    Serial.print("\t0x");
//    Serial.print(anchors[i], HEX);
//    Serial.print(":");
//    Serial.print(range.distance);
//    Serial.print("mm\t");
//    Serial.print(range.RSS);
//    Serial.print("dB; ");
    Serial.print(buf);
  }
  Serial.println();
  count++;
}
