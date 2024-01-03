//
//  SheetsViewModel.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import Foundation
import SwiftUI

final class SheetsViewModel: ObservableObject {
    
    @Published var homeViewSelectedData: HomeViewData?
    
    @Published var selectedDictionary: NSDictionary?
    
    @Published var arrayOfSheets : NSMutableArray?
    
    @Published var currentSelectedIndex : Int?
    
    @Published var mSelectedSheetName : String?
    
    @Published var mSheetNamesArray : Array = []
    
    init(homeViewSelectedData: HomeViewData? = nil, selectedDictionary: NSDictionary? = nil, arrayOfSheets : NSMutableArray? = nil) {
        self.homeViewSelectedData = homeViewSelectedData
        self.selectedDictionary = selectedDictionary
        self.arrayOfSheets = arrayOfSheets
        
        if let sheets = arrayOfSheets, sheets.count > 0 {
            currentSelectedIndex = 0
            
            mSheetNamesArray = []
            
            for dictionary in sheets  {
                    let sheetObj = dictionary as! NSDictionary
                    let downloadedSheetName:String! = (sheetObj.object(forKey: AppConstant.sheet) as! NSDictionary).value(forKey: AppConstant.sheet_name) as? String
                    if downloadedSheetName.count > 0 {
                        mSheetNamesArray.append(downloadedSheetName ?? "")
                    }
            }
                    
            
            if mSheetNamesArray.count > 0 {
                self.mSelectedSheetName = mSheetNamesArray.last as? String
               
                if let sheetName = self.mSelectedSheetName {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationRefreshLayoutWhenSheetIsSelected), object: sheetName)
                }
                
                self.selectedDictionary = sheets.object(at: mSheetNamesArray.count - 1) as? NSDictionary
            }
                   
            
        }
    }
    
    func updateCurrentSheetDetails(){
        
        if let sheets = arrayOfSheets, sheets.count > 0 {
            
            self.selectedDictionary = sheets[currentSelectedIndex!] as? NSDictionary
            
            let downloadedSheetName:String! = (self.selectedDictionary!.object(forKey: AppConstant.sheet) as! NSDictionary).value(forKey: AppConstant.sheet_name) as? String
            
            self.mSelectedSheetName = downloadedSheetName
            
            if let sheetName = self.mSelectedSheetName {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationRefreshLayoutWhenSheetIsSelected), object: sheetName)
            }
        }
        
    }
}
