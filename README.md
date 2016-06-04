BluetoothConnect
===

OSX tool for connecting bluetooth device in command line

# Build

```sh
$ xcrun -sdk macosx swiftc BluetoothConnect/main.swift -Xlinker -rpath -Xlinker "@executable_path/../Frameworks/" -o btconnect
```

# Run

```sh
$ ./btconnect <target device MAC address or device name>
```
