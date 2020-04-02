//
//  WaterDatastore.swift
//  CountWater
//
//  Created by Hilla on 4/1/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import Foundation
import HealthKit

public class WaterDataStore {
    static let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater)!
    
    public func readWater(completion: @escaping (_ totalWater: Double) -> Void) {
        let hkStore = HKHealthStore()
        let calendar = Calendar.current
        let today = Date()
        let midnight = calendar.startOfDay(for: today)
        
        let last24hPredicate = HKQuery.predicateForSamples(withStart: midnight, end: today, options: .strictEndDate)
        let waterQuery = HKSampleQuery(sampleType: WaterDataStore.waterType, predicate: last24hPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) {
            (query, samples, error) in
            
            guard
                error == nil,
                let quantitySamples = samples as? [HKQuantitySample] else {
                    print("Something went wrong: \(String(describing: error))")
                    return
            }
            
            let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            DispatchQueue.main.async {
                completion(total)
            }
        }
        hkStore.execute(waterQuery)
    }
    public func writeWater(amount: Double) {
        let hkStore = HKHealthStore()
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: amount)
        let today = Date()
        let waterQuantitySample = HKQuantitySample(type: WaterDataStore.waterType, quantity: waterQuantity, start: today, end: today)
        
        hkStore.save(waterQuantitySample) { (success, error) in
            print("HK write finished - success: \(success); error: \(String(describing: error))")
            
        }
    }
}
