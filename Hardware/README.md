# Hardware

This directory contains the following:

- Arduino code for the Pozyx platform
- Matlab code to communicate with Arduino on serial port
- Test data generated from the real hardware

## Applications

`Applications` contains the code, divided into individual units known to work.

- `CoordVarCovar`: Report coordinates, variances and covariances from Pozyx to Matlab.
- `Ranging`: Report ranges from tag to anchors over serial port. 
- `GenerateTestData`: Report coordinates from Pozyx to Matlab.
- `Arduino`: Object-oriented interface in Matlab to communicate with Arduino over serial port, with example usage script.

The following applications use the same Arduino code from `GenerateTestData`:

- `RealtimeEstimate`: Combine code from SensorFusion to draw realtime estimates.
- `RealtimeEstimateWIP`: Combine code from SensorFusion to draw realtime estimates, with expected trajectory. Not stable.

## Test Data

`TestData` includes Matlab data with output from the applications, useful for testing.

## Notes regarding Matlab on Linux

### Detecting serial port

On Linux, the following command should be run as root before starting Matlab.
```
ln -s /dev/ttyACM0 /dev/ttyS99
```
where `/dev/ttyACM0` is the name of the Arduino device and `/dev/ttyS99` is an arbitrary name, as Matlab seems to only accept serial port device names starting with `ttyS`. After this you can use `/dev/ttyS99` as normal.

### File lock on the serial port

If `fclose` is not called on the serial port, and you lose the handle to it, simply restart Matlab to get access to the port again. Most of the Matlab code make sure to do this when the handle exists, but beware when you clear the workspace!
