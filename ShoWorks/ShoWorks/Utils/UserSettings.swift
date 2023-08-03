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
        static let previousSerialKey = "previousSecretKey"
        static let recentlyCreated = "recentlyCreated"
        static let selectedChannel = "selectedChannel"
        static let isDemoUserEnabled = "demoUserEnabled"
        static let firstName = "firstName"
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
        
    var previousSerialKey: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.previousSerialKey)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.previousSerialKey)
        }
    }
            
    var selectedChannel: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.selectedChannel)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.selectedChannel)
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
    
    var isDemoUserEnabled: Bool? {
        get {
            UserDefaults.standard.bool(forKey: Keys.isDemoUserEnabled)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.isDemoUserEnabled)
        }
    }
    
    var firstName: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.firstName)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.firstName)
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
