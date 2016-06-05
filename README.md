BluetoothConnect
===

OSX tool for connecting bluetooth device in command line.

## Build

```sh
$ xcrun -sdk macosx swiftc btconnect/main.swift -o build/btconnect
```

## Run

```sh
$ ./build/btconnect <target device MAC address or device name>
```

## Run periodically by launchd

```sh
# edit launchd content appropriately
$ vi launchd.plist
$ cp launchd.plist ~/Library/LaunchAgents/btconnect.plist
$ launchctl load ~/Library/LaunchAgents/btconnect.plist
```
