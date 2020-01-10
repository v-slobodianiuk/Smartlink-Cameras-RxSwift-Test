//
//  UserDefaults+Extensions.swift
//  Smartlink
//
//  Created by Minhaz Mohammad on 6/8/18.
//  Copyright © 2018 SecureNet Technologies, LLC. All rights reserved.
//

import UIKit

enum UserDefaultKeys: String {
    case isLoggedIn
}

extension UserDefaults {
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func setLoggedIn(value: Bool) -> Void {
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func removeLoggedIn() -> Void {
        removeObject(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
}
