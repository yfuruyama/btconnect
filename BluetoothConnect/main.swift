//
//  main.swift
//  BluetoothConnect
//
//  Created by Furuyama Yuuki on 6/2/16.
//  Copyright © 2016 Furuyama Yuuki. All rights reserved.
//

import Foundation
import IOBluetooth


class BTManager: IOBluetoothDeviceInquiryDelegate {
    let target: String // target must be "MAC Address" or "Device Name"
    var btdi: IOBluetoothDeviceInquiry?

    init(target: String) {
        self.target = target
    }

    func startInquiry() {
        self.btdi = IOBluetoothDeviceInquiry(delegate: self)
        self.btdi?.updateNewDeviceNames = true
        self.btdi?.inquiryLength = 3
        self.btdi?.start()
    }

    private func btDeviceAddressToString(address: BluetoothDeviceAddress) -> String {
        let a = [
            (NSString(format: "%02x", address.data.0) as String).uppercaseString,
            (NSString(format: "%02x", address.data.1) as String).uppercaseString,
            (NSString(format: "%02x", address.data.2) as String).uppercaseString,
            (NSString(format: "%02x", address.data.3) as String).uppercaseString,
            (NSString(format: "%02x", address.data.4) as String).uppercaseString,
            (NSString(format: "%02x", address.data.5) as String).uppercaseString,
        ]
        return a.joinWithSeparator("-")
    }

    @objc func deviceInquiryStarted(sender: IOBluetoothDeviceInquiry!) {
        print("Device inquiry started")
    }

    @objc func deviceInquiryDeviceFound(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        let address = device.getAddress()
        let addressMem = address.memory
        let addressStr = self.btDeviceAddressToString(addressMem)
        let name = device.name
        print("Device found: address = \(addressStr), name = \(name)")

        if self.target.uppercaseString == addressStr || self.target == name {
            print("Target device found")

            if !device.isPaired() {
                print("Device must be paired in advance")
                os.exit(1)
            }

            if device.isConnected() {
                print("Device is connected already")
                os.exit(0)
            }

            let ret = device.performSDPQuery(self)
            if ret != kIOReturnSuccess {
                print("SDP query failed")
                os.exit(1)
            } else {
                print("SDP query start...")
            }
        }
    }

    @objc func deviceInquiryUpdatingDeviceNamesStarted(sender: IOBluetoothDeviceInquiry!, devicesRemaining: UInt32) {
        print("Updating device names started: devicesRemaining = \(devicesRemaining)")
    }

    @objc func deviceInquiryDeviceNameUpdated(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!, devicesRemaining: UInt32) {
        print("Device name updated: devicesRemaining = \(devicesRemaining), name = \(device.nameOrAddress)")
    }

    @objc func deviceInquiryComplete(sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        print("Device inquiry completed")
        os.exit(0)
    }
}

let args = Process.arguments
if args.count != 2 {
    print("usage: \(args[0]) <device address (or device name)>")
    os.exit(1)
}

let target = args[1]
print("Target device: \(target)")

let btmanger = BTManager(target: target)
btmanger.startInquiry()

NSRunLoop.currentRunLoop().run()
