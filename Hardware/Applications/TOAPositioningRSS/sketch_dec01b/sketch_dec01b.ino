#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

#include <inttypes.h>

#define NUM_ANCHORS 6
uint8_t num_anchors = NUM_ANCHORS;
uint16_t anchors[NUM_ANCHORS]  = {0x6078, 0x603F, 0x6050, 0x6000, 0x600E, 0x603B};

char buf[128];
unsigned int count = 0;


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
  count++;
  if (count > 20) {
    count = 0;
    Pozyx.begin();
    if (Pozyx.begin() == POZYX_FAILURE) {
      Serial.println(F("ERROR: Unable to connect to POZYX shield"));
      Serial.println(F("Reset required"));
      delay(100);
      abort();
    }
  }
  // uint32_t timestamp[NUM_ANCHORS];
  uint32_t distance[NUM_ANCHORS];
  int16_t RSS[NUM_ANCHORS];
  for (int i = 0; i < num_anchors; i++) {
    device_range_t range;
    Pozyx.doRanging(anchors[i], &range); // THIS IS FOR MORE THAN 4 ANCHORS
    Pozyx.getDeviceRangeInfo(anchors[i], &range);
    // timestamp[i] = range.timestamp;
    distance[i] = range.distance;
    RSS[i] = range.RSS;
  }
  sprintf(
    buf,
    "%" PRIu32 " %" PRIu32 " %" PRIu32 " %" PRIu32 " %" PRIu32 " %" PRIu32
    " %" PRIi16 " %" PRIi16 " %" PRIi16 " %" PRIi16 " %" PRIi16 " %" PRIi16,
    distance[0], distance[1], distance[2], distance[3], distance[4], distance[5],
    RSS[0], RSS[1], RSS[2], RSS[3], RSS[4], RSS[5]
  );
  Serial.println(buf);
}

