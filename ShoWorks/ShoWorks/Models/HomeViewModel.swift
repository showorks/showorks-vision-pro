//
//  HomeViewModel.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    
//    @Published var screenType = ""
    
    @Published var plistDataArray : NSMutableArray?
    @Published var listItems: [HomeViewData]?
    
    func loadPlistArrayWithSheetsDetailData(screenType:AppConstant.AppStartupStatus) async {

        let pListArray = SharedDelegate.sharedInstance.plistSheetDetailArray
        
        if pListArray != nil {
            pListArray!.removeAllObjects()
        }
        
        if screenType == .demoMode
        {
            SharedDelegate.sharedInstance.plistSheetDetailArray = PlistManager.sharedInstance.getPlistDataForDemoMode()
        }
        else
        {
            SharedDelegate.sharedInstance.plistSheetDetailArray = PlistManager.sharedInstance.getPlistData()
        }
        
        DispatchQueue.main.sync {
            plistDataArray = SharedDelegate.sharedInstance.plistSheetDetailArray
        }
        
//        var handler = await S3Handler()
//
//        let v = SharedDelegate.sharedInstance.plistSheetDetailArray
//        print(SharedDelegate.sharedInstance.plistSheetDetailArray)
        
        DispatchQueue.main.async {
            self.loadListWithSheetNames()
        }

    }
    
    func loadListWithSheetNames(){
        let plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
        
        guard plistSheetDetailArray != nil else {
            return
        }
        
        listItems = []
        
        for sheetDic in plistSheetDetailArray {
           
            let sheetObj = sheetDic as! NSDictionary
            let sheetInfoObj = sheetObj[AppConstant.sheet] as! NSDictionary

            if let afileName = sheetInfoObj[AppConstant.sheet_name] as? String , let created =  sheetInfoObj[AppConstant.sheet_created] as? String {
                let homeViewDataObj = HomeViewData(fileName: afileName, createdTime: created)
                
                listItems?.append(homeViewDataObj)
            }
         }
        
        print(listItems)
    }

}
