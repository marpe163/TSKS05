# Hardware

This directory contains the following:

- MATLAB code for the Pozyx platform
- Matlab code to communicate with Arduino on serial port
- Test data generated from the real hardware

## Applications

`Applications` contains the code, divided into individual units known to work.

- `CoordVarCovar`: Report coordinates, variances and covariances from Pozyx to Matlab.
- `Ranging`: Report ranges from tag to anchors over serial port.
- `GenerateTestData`: Report coordinates from Pozyx to Matlab.
- `Arduino`: Object-oriented interface in Matlab to communicate with Arduino over serial port, with example usage script.
- `TOAPositioning`: Do positioning with TOA, compare with Pozyx built-in positioning.
- `TOAPositioningRSS`: TOA positioning with received signal strength.

## ArduinoSketches

`ArduinoSketches` contains the Arduino sketches (programs) used in the project.

- `CoordVarCovar`: Report coordinates, variances and covariances. Works with the MATLAB application of the same name.
- `Position`: Report the position using the build-in positioning of Pozyx. Used with the `GenerateTestData` application.
- `RangeRSS`: Report the range and received signal strength to anchors. Used in `TOAPositioningRSS` application and the GUI with TOA.

Note that the user needs to check and update the following data in the sketches to match the hardware setup:

- Number of anchors
- Anchor identifiers (Must also match those coded in the MATLAB scripts)
- Anchor positions (For using the built-in positioning of Pozyx)

## Test Data

`TestData` includes Matlab data with output from the applications, useful for testing.

## Notes regarding Matlab on Linux

There are lots of problems when running Matlab on Linux.

### Detecting serial port

On Linux, the following command should be run as root before starting Matlab.
```
ln -s /dev/ttyACM0 /dev/ttyS99
```
where `/dev/ttyACM0` is the name of the Arduino device and `/dev/ttyS99` is an arbitrary name, as Matlab seems to only accept serial port device names starting with `ttyS`. After this you can use `/dev/ttyS99` as normal.

### File lock on the serial port

If `fclose` is not called on the serial port, and you lose the handle to it, you can use the command `delete(instrfind)` to close the serial port.

### UI problems with multiple windows

If you find your mouse clicking through figure and popup windows: (this is hard to explain, but you will know when you encounter this)

This may be a bug of Matlab on Linux. A workaround is to remove other keyboard layouts except the one you are using.

See also: https://josm.openstreetmap.de/ticket/10430#comment:16
