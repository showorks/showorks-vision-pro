//
//  SheetUtility.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import Foundation
import SwiftUI

class SheetUtility {
    
    static let sharedInstance = SheetUtility()
   
    var checkmarkIndex:Int?
    var exhibitorIndex:Int?
    var clubIndex:Int?
    var entryIdIndex:Int?
    var descriptionIndex:Int?
    var ribbonIndex:Int?
    var placeIndex:Int?
    var tagIndex:Int?
    
    init(checkmarkIndex: Int? = nil, exhibitorIndex: Int? = nil, clubIndex: Int? = nil, entryIdIndex: Int? = nil, descriptionIndex: Int? = nil, ribbonIndex: Int? = nil, placeIndex: Int? = nil, tagIndex: Int? = nil) {
        self.checkmarkIndex = checkmarkIndex
        self.exhibitorIndex = exhibitorIndex
        self.clubIndex = clubIndex
        self.entryIdIndex = entryIdIndex
        self.descriptionIndex = descriptionIndex
        self.ribbonIndex = ribbonIndex
        self.placeIndex = placeIndex
        self.tagIndex = tagIndex
    }
    
    init(){
        checkmarkIndex = -1
        exhibitorIndex = -1
        clubIndex = -1
        entryIdIndex = -1
        descriptionIndex = -1
        ribbonIndex = -1
        placeIndex = -1
        tagIndex = -1
    }
    
    /**
     @function    :isKioskModeEnabledInSheet:
     @discussion    :This will check in the current sheet for Kiosk mode enabled or not.
     @param            :sheetDic - Contains complete detail of sheet
     @return        :YES - if Kiosk mode enabled, NO - Otherwise
     */
    func isKioskModeEnabledInSheet(sheetDic:NSDictionary!) -> Bool {
        if (sheetDic == nil)
            {return false}

        let sheetInfoDic:NSDictionary! = sheetDic.object(forKey: AppConstant.sheet) as! NSDictionary

        let keyExists = sheetInfoDic[AppConstant.SheetInfoKeySheetType] != nil

        if keyExists == false {
            return false
        }
        
        let sheetType = sheetInfoDic[AppConstant.SheetInfoKeySheetType] as! String

        if (sheetType == AppConstant.SheetInfoKeySheetTypeKiosk)
            {return true}

        return false
    }
    
    /**    @function    :isScanningAllowedInSheet:
     @discussion    :This will tell, if current sheet have ability to scan or not
     @param            :sheetDic - Contains complete detail of sheet
     @return        :YES - if allowscanning, NO - Otherwise
     */
    func isScanningAllowedInSheet(sheetDic:NSDictionary!) -> Bool {
        if (sheetDic == nil)
            {return false}

        let sheetInfoDic:NSDictionary! = sheetDic.object(forKey: AppConstant.sheet) as! NSDictionary

        let keyExists = sheetInfoDic[AppConstant.SheetInfoKeySheetType] != nil

        return keyExists
    }

}
