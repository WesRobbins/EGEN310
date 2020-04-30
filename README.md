# EGEN310
This is repository for all files related to the semester project in EGEN 310


# READme for Users
This applicaion is very simple to use. The left slide bar controls power to right wheels. The right slide bar controls power 
to the rght wheels. If a slider is brought to 10(the top of screen) it will be full speed forward. If a slider is brought to -10 it will be full speed backwards. If it is at 0 that set of wheel will not be moving. The stop button brings both sliders to 0. The bluetooth connectivity should be done automatically when our specific microcontroller is on and in range.


# READme for Developers
All changes realated to bluetooth can be found under the Apple Core Bluetooth API. All bluetooth related code is in particlePeripheral.swift file.
All viewcontroller related code is in the file viewcontroller.swift.
All functionality related code the file AppDelegate.swift
Configuration inforation is found in info.plist file
It is recomended to use an apple running xcode to modify this application
