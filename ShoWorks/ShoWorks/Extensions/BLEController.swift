//
//  BLEController.swift
//  ShoWorks
//
//  Created by Lokesh on 22/09/23.
//

import Foundation
import CoreBluetooth

class BLEController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
   
    var centralManager: CBCentralManager!
    var foundPeripheral: CBPeripheral!
   
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
   
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            beginSearchingDevices()
        }
    }
    
    func beginSearchingDevices(){
        switch centralManager.state {
          case .unknown:
            print("status is unknown")
          case .resetting:
            print("resetting")
          case .unsupported:
            print("The platform/hardware doesn't support Bluetooth Low Energy.")
          case .unauthorized:
            print("The app is not authorized")
          case .poweredOn:
            print("The device is powered on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
          case .poweredOff:
            print("The external device is currently powered off")
        @unknown default:
            print("Not working")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceName = peripheral.name?.lowercased() ?? nil
        print(deviceName)
        if (Utilities.sharedInstance.checkStringContainsText(text: deviceName) && deviceName!.contains("barcode scanner")){
            foundPeripheral = peripheral
            centralManager.stopScan()
            centralManager.connect(foundPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.foundPeripheral.delegate = self
        self.foundPeripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

        if let error = error{
            print("SOME ERROR HERE didDiscoverServices")
            return
        }

        peripheral.services?.forEach({ service in
            self.foundPeripheral.discoverCharacteristics(nil, for: service)
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error{
            print("SOME ERROR HERE didDiscoverCharacteristicsFor")
            return
        }
        
        service.characteristics?.forEach { characteristic in
            print("UUID of characteristic")
            print(characteristic.uuid)
            foundPeripheral.setNotifyValue(true, for: characteristic)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print("SOME ERROR HERE didUpdateNotificationStateFor")
            print(error)
            return
        }
        
        if characteristic.isNotifying{
            print("Notification begin for \(characteristic)")
        }else{
            print("Notification failure for \(characteristic)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            print("SOME ERROR HERE didUpdateValueFor")
            return
        }
        
        if characteristic.value != nil {
            let foundString = String(decoding: characteristic.value!, as: UTF8.self)
            print(foundString)
        }
    }
}
