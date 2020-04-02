//
//  HealthKitSetupAssistant.swift
//  CountWater
//
//  Created by Hilla on 3/29/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import HealthKit

public class HealthKitSetupAssistant {
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    public func authorize(completion: @escaping (Bool, Error?) -> Void) {
        //1. Check to see if HealthKit Is Available on this device
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        //2. Prepare the data types that will interact with HealthKit
        guard let water = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        //3. Prepare a list of types you want HealthKit to read and write
        let healthKitTypesToWrite: Set<HKSampleType> = [water]
        let healthKitTypesToRead: Set<HKObjectType> = [water]
        
        //4. Request Authorization
        HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                             read: healthKitTypesToRead,
                                             completion: completion)
    }
}
