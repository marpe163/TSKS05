#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

#include <inttypes.h>

#define NUM_ANCHORS 6
uint8_t num_anchors = NUM_ANCHORS;
uint16_t anchors[NUM_ANCHORS]  = {0x6078, 0x603F, 0x6050, 0x6000, 0x600E, 0x603B};
int32_t anchors_x[NUM_ANCHORS] = { 14750,   4950,  -2100,  25250,   9750,  -2250};
int32_t anchors_y[NUM_ANCHORS] = {   300,      0,   2300,   2250,   1900,   7000};
int32_t anchors_z[NUM_ANCHORS] = {  1600,   1600,   1950,   1050,   2400,   1000};

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

  // add anchors
  device_coordinates_t dev;
  unsigned i;
  for (i=0; i<NUM_ANCHORS; i++) {
    dev.network_id = anchors[i];
    dev.flag = 1;
    dev.pos.x = anchors_x[i];
    dev.pos.y = anchors_y[i];
    dev.pos.z = anchors_z[i];
    int result = Pozyx.addDevice(dev);
    if (result != POZYX_SUCCESS) {
      Serial.println(F("addDevice failed"));
    }
  }
}

void loop() {
  coordinates_t position;
  Pozyx.doPositioning(&position, POZYX_2_5D, 0);
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
  Serial.print(buf);
  sprintf(buf, " %" PRIi32 " %" PRIi32 " %" PRIi32, position.x, position.y, position.z);
  Serial.println(buf);
}

