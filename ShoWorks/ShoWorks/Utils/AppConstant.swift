//
//  AppConstant.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation

struct AppConstant {
    
    // Attributes/keys
    static let sheet_file_name = "Filename"
    static let sheet_attributes = "Attributes"
    static let sheet_template = "Template"
    static let sheet = "Sheet"
    static let sheet_name = "Name"
    static let sheet_allow_division_change = "allowdivisionchange" // SHEET_ALLOW_DIVISION_CHANGE
    static let sheet_allow_class_change = "allowclasschange" //SHEET_ALLOW_CLASS_CHANGE
    static let sheet_created = "Created" //SHEET_CREATED
    static let sheet_updated = "Updated" //SHEET_UPDATED
    static let sheet_departments = "Departments" //SHEET_UPDATED
    static let sheet_entries = "Entries" //SHEET_UPDATED
    static let sheet_divisions = "Divisions" //SHEET_UPDATED
    static let sheet_classes = "Classes" //SHEET_UPDATED

    
    static let plistManagerDemoFileName = "SheetsData.plist";
    static let AWSRegionUSEast1 = "us-east-1";
    static let bucketName = "sw2012tablet"

    static let status_void = "v"
    static let status_fresh = "l"
    static let status_complete = "c"
    static let status_draft = "d"
    
    static let SerialNumberMinLength = 18
    static let SerialNumberMaxLength = 22
    
    // File paths
    
    static let append_cache_path_with_plist_file = "Library/Caches/%@/SheetsData.plist" // previously called as APPEND_CACHE_PATH_WITH_PLIST_FILE

    static let path_from_cache_from_home_directory = "Library/Caches/%@" // previously called as PATH_FOR_CACHES_FROM_HOME_DIRECTORY
    
    static let append_cache_path_with_archived_plist = "Library/Caches/%@/ArchivedData.plist" // previously called as APPEND_CACHE_PATH_WITH_ARCHIVED_PLIST_FILE

    
    enum SyncType {
      case DOWNLOAD, UPLOAD
    }

    static let HomeScreenSyncInProcessNotification = "HomeScreenSyncInProcessNotification"
    static let ChangeRibbonColorOrderNotification = "ChangeRibbonColorOrderNotification"
    static let ShowSerialPromptNotification = "ShowSerialPromptNotification"
    static let SettingsSlaveDoneNotification = "SettingsSlaveDoneNotification"
    static let SettingsSlaveHTMLNotification = "SettingsSlaveHTMLNotification"
    static let SettingsSlaveQRCodeHTMLNotification = "SettingsSlaveQRCodeHTMLNotification"
    static let SettingsSlaveLoadUserModeNotification = "SettingsSlaveLoadUserModeNotification"
    static let SettingsSlaveLoadDemoModeNotification = "SettingsSlaveLoadDemoModeNotification"
    static let PlistSyncedWithServerFailure = "PlistSyncedWithServerFailure"
    
    enum AppStartupStatus {
      case demoMode, fetchSheetFromLocal, fetchSheetFromServer
    }
}


extension Notification.Name {
    static let homeSyncingNotification = Notification.Name(AppConstant.HomeScreenSyncInProcessNotification)
}
