//
//  InterfaceController.swift
//  CountWaterWatch Extension
//
//  Created by Hilla on 3/29/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController {
    @IBOutlet var amountLabel: WKInterfaceLabel!
    @IBOutlet var cupButton: WKInterfaceButton!
    @IBOutlet var bottleButton: WKInterfaceButton!
    
    let hkStore = HKHealthStore()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        authorizeHealthKit()
        readWater()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func onClickCup() {
        writeWater(amount: 200)
    }
    @IBAction func onClickBottle() {
        writeWater(amount: 450)
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
                self.amountLabel.setText("\(total) ml")
            }
        })
    }
    
    private func writeWater(amount: Double) {
        WaterDataStore().writeWater(amount: amount)
    }
}
