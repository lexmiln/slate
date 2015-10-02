# slate
iOS/Swift control interface for our living room. Shows the time and weather, provides buttons to control the AV system, projector and Playstation.

![Slate system image](http://x13n.com/alex/slate-system.jpg)

3D model for the IR transmitter mount here: http://www.shapeways.com/product/2CGSZ796Y/blaster-prong-rounded

The Swift app is essentially just a pretty client to an HTTP home automation server running on a Raspberry Pi. The server drives a pair of infrared transmitters, and sends Wake-on-LAN packets as needed.
