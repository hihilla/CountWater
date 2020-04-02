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
    
    let hkStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        design(button: cupButton)
        design(button: bottleButton)
        authorizeHealthKit()
        readWater()
    }
    
    private func design(button: UIButton) {
        let buttonHeight = button.frame.size.height
        button.layer.cornerRadius = buttonHeight / 2.0
    }
    
    @IBAction func onTouchUpInsideCupButton(_ sender: UIButton) {
        writeWater(amount: 200)
    }
    
    @IBAction func onTouchUpInsideBottleButton(_ sender: UIButton) {
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
        print("triggering to iphone")
        self.readWater()
        completionHandler()
    }
    
    
    @objc private func readWater() {
        print("read water iphone")
        WaterDataStore().readWater(completion: {total in
            print("total water: \(total)")
            DispatchQueue.main.async {
                self.amountLabel.text = "\(total) ml"
            }
        })
    }
    
    private func writeWater(amount: Double) {
        WaterDataStore().writeWater(amount: amount)
    }
}

