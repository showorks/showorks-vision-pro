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
    @Published var isDataLoaded: Bool?
    
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
                
                var departmentsCount = 0
                
                if let departments = sheetObj[AppConstant.sheet_departments] as? NSMutableArray {
                    departmentsCount = departments.count
                }
                
                let createdTime = Utilities.sharedInstance.getTimeAccordingToDateOrMinutesAgoAccordingly(time: created) ?? ""

                let entriesCount = Int(sheetInfoObj[AppConstant.sheet_entries] as? String ?? "0") ?? 0
                
                let divisionsCount = getDivisionsCountOfSheet(sheetDic: sheetObj)
                
                let classesCount = getClassesCountOfSheet(sheetDic: sheetObj)
                
                let homeViewDataObj = HomeViewData(fileName: afileName, createdTime: createdTime, numberOfDepartments: String.init(format: "%ld", departmentsCount), numberOfClasses: String.init(format: "%ld", classesCount), numberOfDivisions: String.init(format: "%ld", divisionsCount), numberOfEntries: String.init(format: "%ld", entriesCount))
                
                listItems?.append(homeViewDataObj)
            }
         }
        
        if let listItemsArray = listItems {
            isDataLoaded = true
        }else{
            isDataLoaded = false
        }
    }
    
    func getDivisionsCountOfSheet(sheetDic:NSDictionary) -> Int{
        
        var totalDivisions = 0;
        
        if let departments = sheetDic[AppConstant.sheet_departments] as? NSMutableArray {
            
            for department in departments {
                
                let departmentObj = department as! NSDictionary
                
                if let divisions = departmentObj[AppConstant.sheet_divisions] as? NSMutableArray {
                    totalDivisions += divisions.count
                }
            }
        }
        
        return totalDivisions
    }

    func getClassesCountOfSheet(sheetDic:NSDictionary) -> Int{
        
        var totalClasses = 0;
        
        if let departments = sheetDic[AppConstant.sheet_departments] as? NSMutableArray {
            
            for department in departments {
                
                let departmentObj = department as! NSDictionary
                
                if let divisions = departmentObj[AppConstant.sheet_divisions] as? NSMutableArray {
                    
                    for division in divisions {
                        
                        let divisionObj = division as! NSDictionary
                        
                        if let classes = divisionObj[AppConstant.sheet_classes] as? NSMutableArray {
                            totalClasses += classes.count
                        }
                    }
                }
            }
        }
        
        return totalClasses
    }

}
