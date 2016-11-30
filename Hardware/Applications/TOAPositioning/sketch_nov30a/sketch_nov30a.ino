#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

#define NUM_ANCHORS 4
uint8_t num_anchors = NUM_ANCHORS;
uint16_t anchors[NUM_ANCHORS]  = {0x6078, 0x603F, 0x6050, 0x6000};
int32_t anchors_x[NUM_ANCHORS] = {  4950,  -2550,   4950,      0};
int32_t anchors_y[NUM_ANCHORS] = {  7000,   7000,      0,      0};
int32_t anchors_z[NUM_ANCHORS] = {  1000,   1000,   1600,   1250};

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
  printCoord(&position);

  for (int i = 0; i < num_anchors; i++) {
    device_range_t range;
    Pozyx.doRanging(anchors[i], &range); // THIS IS FOR MORE THAN 4 ANCHORS
    Pozyx.getDeviceRangeInfo(anchors[i], &range);
    sprintf(buf, "%u ", range.distance);
    Serial.print(buf);
  }
  Serial.println();
}

void printCoord(coordinates_t* coor) {
  sprintf(buf, "%i ", coor->x);
  Serial.print(buf);
  sprintf(buf, "%i ", coor->y);
  Serial.print(buf);
  sprintf(buf, "%i ", coor->z);
  Serial.print(buf);
}
