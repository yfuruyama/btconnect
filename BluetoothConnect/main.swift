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
    let targetDeviceAddress: String
    var btdi: IOBluetoothDeviceInquiry?

    init(targetDeviceAddress: String) {
        self.targetDeviceAddress = targetDeviceAddress
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
        print("Started device inquiry")
    }

    @objc func deviceInquiryDeviceFound(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!) {
        let address = device.getAddress()
        let addressMem = address.memory
        let addressStr = self.btDeviceAddressToString(addressMem)
        print("Device found: address = \(addressStr)")

        if self.targetDeviceAddress == addressStr {
            print("Target device found")
            let ret = device.performSDPQuery(self)
            if ret != kIOReturnSuccess {
                print("SDP query failed")
            }
        }
    }

    @objc func deviceInquiryUpdatingDeviceNamesStarted(sender: IOBluetoothDeviceInquiry!, devicesRemaining: UInt32) {
        print("Started updating device names")
    }

    @objc func deviceInquiryDeviceNameUpdated(sender: IOBluetoothDeviceInquiry!, device: IOBluetoothDevice!, devicesRemaining: UInt32) {
        print("Updated device name")
    }

    @objc func deviceInquiryComplete(sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
        print("Device inquiry completed")
        os.exit(0)
    }
}

print("Start...")

let btmanger = BTManager(targetDeviceAddress: "00-06-66-4B-28-A0")
btmanger.startInquiry()

NSRunLoop.currentRunLoop().run()