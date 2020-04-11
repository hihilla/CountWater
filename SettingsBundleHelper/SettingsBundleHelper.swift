//
//  SettingsBundleHelper.swift
//  CountWater
//
//  Created by Hilla on 4/11/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import Foundation
class SettingsBundleHelper {
    static let DefaultBottleSize = 450
    static let DefaultCupSize = 200
    struct SettingsBundleKeys {
        static let Reset = "reset"
        static let BottleSizeKey = "bottle_size"
        static let CupSizeKey = "cup_size"
    }
    
    class func checkAndExecuteSettings() {
        let reset: Bool = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset)
        if reset {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
            let appDomain: String? = Bundle.main.bundleIdentifier
            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            // reset userDefaults..
            UserDefaults.standard.set(SettingsBundleHelper.DefaultBottleSize, forKey: SettingsBundleKeys.BottleSizeKey)
            UserDefaults.standard.set(SettingsBundleHelper.DefaultCupSize, forKey: SettingsBundleKeys.CupSizeKey)
        }
    }
}
