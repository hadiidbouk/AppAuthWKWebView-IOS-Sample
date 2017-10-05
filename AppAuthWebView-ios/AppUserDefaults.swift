//
//  UserDefaults.swift
//  AppAuthTest
//
//  Created by Hadi Dbouk on 10/2/17.
//  Copyright © 2017 Hadi Dbouk. All rights reserved.
//

import AppAuth

class AppUserDefaults {
    
    
    static func saveState(authState:OIDAuthState?) {
        if(authState != nil){
            let archivedAuthState = NSKeyedArchiver.archivedData(withRootObject: authState!)
            UserDefaults.standard.set(archivedAuthState, forKey: AppAuthStateKey)
        }
        else {
            UserDefaults.standard.set(nil, forKey: AppAuthStateKey)
        }
        
        UserDefaults.standard.synchronize()

    }
    
    static func loadState() -> OIDAuthState? {
        if let archivedAuthState = UserDefaults.standard.object(forKey: AppAuthStateKey) as? Data {
            if let authState = NSKeyedUnarchiver.unarchiveObject(with: archivedAuthState) as? OIDAuthState {
                return authState
            } else {  return nil  }
        } else { return nil }
    }
}
