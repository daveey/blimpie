//
//  ViewController.swift
//  Blimpie
//
//  Created by David Braginsky on 12/3/15.
//  Copyright © 2015 daveey. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
  
  // BLE
  var centralManager : CBCentralManager!
  var sensorTagPeripheral : CBPeripheral!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Initialize central manager on load
    centralManager = CBCentralManager(delegate: self, queue: nil)
    
  }

  // Check status of BLE hardware
  func centralManagerDidUpdateState(central: CBCentralManager) {
    if central.state == CBCentralManagerState.PoweredOn {
      // Scan for peripherals if BLE is turned on
      central.scanForPeripheralsWithServices(nil, options: nil)
    }
    else {
      // Can have different conditions for all states if needed - print generic message for now
      print("Bluetooth switched off or not initialized")
    }
  }
  
  // Check out the discovered peripherals to find Sensor Tag
  func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    
    let deviceName = "SensorTag"
    let nameOfDeviceFound = (advertisementData as NSDictionary).objectForKey(CBAdvertisementDataLocalNameKey) as? NSString
    
    if (nameOfDeviceFound == deviceName) {
      // Update Status Label
      
      // Stop scanning
      self.centralManager.stopScan()
      // Set as the peripheral to use and establish connection
      self.sensorTagPeripheral = peripheral
      self.sensorTagPeripheral.delegate = self
      self.centralManager.connectPeripheral(peripheral, options: nil)
    }
    else {
      print("not found")
    }
  }
  
  // If disconnected, start searching again
  func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
print("disconnected")
    central.scanForPeripheralsWithServices(nil, options: nil)
  }


  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

