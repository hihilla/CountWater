//
//  UserDefaultsExtension.swift
//  CountWater
//
//  Created by Hilla on 4/11/20.
//  Copyright © 2020 Hilla Guz. All rights reserved.
//

import Foundation

extension UserDefaults {
    func integer(forKey: String, withDefault: Int) -> Int {
        let val = self.integer(forKey: forKey)
        guard val > 0 else {
            return withDefault
        }
        return val
    }
}
