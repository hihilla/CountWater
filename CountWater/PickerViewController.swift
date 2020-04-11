//
//  PickerViewController.swift
//  CountWater
//
//  Created by Hilla on 4/11/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var doneButton: UIButton!
    
    var amountRange: [Int] = [Int]()
    var pickerData: [String] = [String]()
    
    var selectedAmount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design(button: doneButton)
            
        pickerView.delegate = self
        pickerView.dataSource = self
        
        amountRange = (10..<1000).filter{ $0 % 10 == 0 }
        pickerData = amountRange.map{ "\($0) ml" }
    }
    
    private func design(button: UIButton) {
        let buttonHeight = button.frame.size.height
        button.layer.cornerRadius = buttonHeight / 2.0
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        selectedAmount = amountRange[row]
    }
    
    @IBAction func onTouchUpInsideDoneButton(_ sender: UIButton) {
        WaterDataStore().writeWater(amount: Double(selectedAmount))
        self.dismiss(animated: true, completion: nil)
    }
}
