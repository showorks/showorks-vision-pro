//
//  UserSettings.swift
//  ShoWorks
//
//  Created by Lokesh on 19/07/23.
//

import Foundation

class UserSettings {
    
    static let shared = UserSettings()
    
    private init() {}
    struct Keys {
        static let serialKey = "serialKey"
        static let accessKey = "accessKey"
        static let secretKey = "secretKey"
        static let recentlyCreated = "recentlyCreated"
    }
    
    var serialKey: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.serialKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.serialKey)
        }
    }
        
    var accessKey: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.accessKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.accessKey)
        }
    }
    
    var secretKey: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.secretKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.secretKey)
        }
    }
    
    var recentlyCreated: Bool? {
        get {
            UserDefaults.standard.bool(forKey: Keys.recentlyCreated)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.recentlyCreated)
        }
    }
    
    func removeAllUserSettings() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}
