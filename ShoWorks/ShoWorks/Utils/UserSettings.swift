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
        static let selectedMode = "selectedMode"
        static let roundRobinBackgroundImage = "roundRobinBackgroundImage"
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
    
    // 1 being check-in
    // 2 being judge
    var selectedMode: Int? {
        get {
            UserDefaults.standard.integer(forKey: Keys.selectedMode)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.selectedMode)
        }
    }

    // 0 = background_new_1
    // 1 = background_new_2
    // 2 = background_new_3
    // 3 = background_new_4
    // 4 = background_new_5
    // 5 = background_new_6
    // 6 = background_new_7
    var roundRobinBackgroundImageIndex: Int? {
        get {
            UserDefaults.standard.integer(forKey: Keys.roundRobinBackgroundImage)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.roundRobinBackgroundImage)
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
