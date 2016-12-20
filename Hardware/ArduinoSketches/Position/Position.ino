#include <Pozyx.h>
#include <Pozyx_definitions.h>
#include <Wire.h>

#define NUM_ANCHORS 4

uint16_t anchors[NUM_ANCHORS]  = {0x6000, 0x603F, 0x6050, 0x6078};
int32_t anchors_x[NUM_ANCHORS] = {     0,      0,   1600,   1600};
int32_t anchors_y[NUM_ANCHORS] = {     0,    600,    600,      0};
int32_t anchors_z[NUM_ANCHORS] = {     0,      0,      0,      0};

void setup() {
  unsigned i;
  
  Serial.begin(115200);

  if (Pozyx.begin() == POZYX_FAILURE) {
    Serial.println(F("ERROR: Unable to connect to POZYX shield"));
    Serial.println(F("Reset required"));
    delay(100);
    abort();
  }

  // add anchors
  device_coordinates_t dev;
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
}

void printCoord(coordinates_t* coor) {
  Serial.print(coor->x);
  Serial.print(" ");
  Serial.print(coor->y);
  Serial.print(" ");
  Serial.print(coor->z);
  Serial.print(" ");
  Serial.println();
}
