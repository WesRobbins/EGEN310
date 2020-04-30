//
//  ViewController.swift
//  car_control2
//
//  Created by Wes Robbins on 1/28/20.
//  Copyright © 2020 Wes Robbins. All rights reserved.
//

import UIKit
import AVKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    private var centralManager : CBCentralManager!
    var peripheral : CBPeripheral!

    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label1a: UILabel!
    @IBOutlet var label2a: UILabel!
    
    
    
    @IBOutlet var slider1a: UISlider!
    @IBOutlet var slider2a: UISlider!
    @IBAction func slider1(_ sender: UISlider) {
        label1a.text = String(Int(abs(sender.value)))
        if (Int(sender.value) > 0){
            label1.text = "Forward"
        }
        else if (Int(sender.value) < 0){
            label1.text = "Backwards"
        }
        else {
            label1.text = "Stopped"
        }
        
    }
    

    @IBAction func slider2(_ sender: UISlider) {
        label2a.text = String(Int(abs(sender.value)))
        if (Int(sender.value) > 0){
            label2.text = "Forward"
        }
        else if (Int(sender.value) < 0){
            label2.text = "Backwards"
        }
        else {
            label2.text = "Stopped"
        }
    }
    
    
    @IBAction func stop(_ sender: UIButton) {
        slider1a.value = 0
        slider2a.value = 0
        label1a.text = "0"
        label2a.text = "0"
        label1.text = "Stopped"
        label2.text = "Stopped"
        
    }
    
    
    @IBAction func musicPlay(_ sender: UIButton) {
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        slider1a.transform = slider1a.transform.rotated(by: CGFloat(1.5 * Float.pi))
        slider2a.transform = slider2a.transform.rotated(by: CGFloat(1.5 * Float.pi))
        
        let url = Bundle.main.url(forResource: "americanwoman", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = 0
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    
    //START OF BLUETOOTH METHODS
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central state update on")
        if central.state != .poweredOn {
            print("central is not powered on")
        }
        else {
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("LED service found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID,
                                                        ParticlePeripheral.greenLEDCharacteristicUUID,
                                                        ParticlePeripheral.blueLEDCharacteristicUUID], for: service)
                    return
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID {
                    print("Red LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID {
                    print("Green LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID {
                    print("Blue LED characteristic found");
                }
            }
        }
    }
    
    
    


}

class CustomSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 20))
    }

}
