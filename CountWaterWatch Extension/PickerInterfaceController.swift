//
//  PickerInterfaceController.swift
//  CountWater
//
//  Created by Hilla on 4/11/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class PickerInterfaceController: WKInterfaceController {
    @IBOutlet var picker: WKInterfacePicker!
    
    var amountRange: [Int] = [Int]()
    var pickerData: [String] = [String]()
    
    var selectedAmount = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        amountRange = (10..<1000).filter{ $0 % 10 == 0 }
        let items = amountRange.map{ buildWKPickerItem(amount: $0) }
        picker.setItems(items)
    }
    
    private func buildWKPickerItem(amount: Int) -> WKPickerItem {
        let title = "\(amount) ml"
        let item = WKPickerItem()
        item.caption = title
        item.title = title
        return item
    }
    
    @IBAction func pickerChanged(_ value: Int) {
        selectedAmount = amountRange[value]
    }
    
    @IBAction func onTouchUpInsideDoneButton() {
        WaterDataStore().writeWater(amount: Double(selectedAmount))
        self.dismiss()
    }
    
}
