//
//  ViewController.swift
//  CountWater
//
//  Created by Hilla on 3/29/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var cupButton: UIButton!
    @IBOutlet var bottleButton: UIButton!
    @IBOutlet var customButton: UIButton!
    
    let hkStore = HKHealthStore()
    var bottleAmount = SettingsBundleHelper.DefaultBottleSize
    var cupAmount = SettingsBundleHelper.DefaultCupSize
    
    deinit { //Not needed for iOS9 and above. ARC deals with the observer in higher versions.
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design(button: cupButton)
        design(button: bottleButton)
        design(button: customButton)
        authorizeHealthKit()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.defaultsChanged),
            name: UserDefaults.didChangeNotification,
            object: nil
        )
        defaultsChanged()
        readWater()
    }
    
    private func design(button: UIButton) {
        let buttonHeight = button.frame.size.height
        button.layer.cornerRadius = buttonHeight / 2.0
    }
    
    @IBAction func onTouchUpInsideCupButton(_ sender: UIButton) {
        writeWater(amount: Double(cupAmount))
    }
    
    @IBAction func onTouchUpInsideBottleButton(_ sender: UIButton) {
        writeWater(amount: Double(bottleAmount))
    }
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant().authorize { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
            self.startObserving()
        }
    }
    
    func startObserving() {
        let query: HKObserverQuery = HKObserverQuery(sampleType: WaterDataStore.waterType, predicate: nil, updateHandler: self.waterChangedHandler)
        hkStore.execute(query)
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    @objc func defaultsChanged(){
        SettingsBundleHelper.checkAndExecuteSettings()
        let bottleSize = UserDefaults.standard.integer(forKey: SettingsBundleHelper.SettingsBundleKeys.BottleSizeKey, withDefault: SettingsBundleHelper.DefaultBottleSize)
        bottleButton.setTitle("1 bottle (\(bottleSize) ml)", for: .normal)
        bottleAmount = bottleSize
        
        let cupSize = UserDefaults.standard.integer(forKey: SettingsBundleHelper.SettingsBundleKeys.CupSizeKey, withDefault: SettingsBundleHelper.DefaultCupSize)
        cupButton.setTitle("1 cup (\(cupSize) ml)", for: .normal)
        cupAmount = cupSize
    }
    
    func waterChangedHandler(query: HKObserverQuery, completionHandler: @escaping HKObserverQueryCompletionHandler, error: Error?) {
        guard error == nil else {
            print("failed trigger \(String(describing: error))")
            return
        }
        self.readWater()
        completionHandler()
    }
    
    
    @objc private func readWater() {
        WaterDataStore().readWater(completion: {total in
            print("total water: \(total)")
            DispatchQueue.main.async {
                self.amountLabel.text = "\(Int(total)) ml"
            }
        })
    }
    
    private func writeWater(amount: Double) {
        WaterDataStore().writeWater(amount: amount)
    }
}

