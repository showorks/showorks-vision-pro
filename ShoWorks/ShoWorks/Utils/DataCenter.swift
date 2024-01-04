//
//  DataCenter.swift
//  ShoWorks
//
//  Created by Lokesh on 19/07/23.
//

import Foundation
import SwiftUI
import AWSS3
import AWSMobile
import AWSClientRuntime
import UIKit
import AWSS3Outposts
import AWSS3Control

typealias AWSS3ObjectsFetchingCallback = (_ objects: NSMutableArray) -> Void
typealias AWSS3ListObjectsFetchingCallback = (_ objects: [String]) -> Void
typealias AWSS3ListFileNamesFetchingCallback = (_ handler: S3Handler, _ objects: [String]) -> Void
typealias AWSS3DownloadCompletionCallback = (_ downloadCompleted: Bool) -> Void

class DataCenter : NSObject,SheetParserDelegate,ObservableObject {
    
    static let sharedInstance = DataCenter()
        
    var tempCurrentFreshSheetCount:Int?
    
    var hasComeFromAFlowWhenNoNewFilesAreThere:Bool

    var hasComeFromAFlowWhenFoundSomethingAtleast:Bool
    
    var accessKey:String?
    
    var secretKey:String?
    
    var currentSheetKey:String?

    var sheetsData: NSMutableArray?
        
    @Published var searchedRecords: [Entry] = [
//        .init(exhibitor: "Coulter Michaels", department: "Home & Hobby", club: "French Valley 4H", entryNumber: "5948", wen: "C2FB04", division: "203 - Drawing", Class: "04 - Oil - Representational", description: "Mary's Orchids", validationNumber: "671858728", entryValidationDate: "09/28/2012", stateFair: "I will take to state fair", salePrice: "218.99",isAllowedForSale: true)
    ]
    
    @Published var isDeviceConnected = false
    
    @Published var searchedSelectedIndex = 0
    
    @Published var focusKeyboard = false
    
    /// Default initializer
    private override init() {
        
        self.hasComeFromAFlowWhenNoNewFilesAreThere = false
        self.hasComeFromAFlowWhenFoundSomethingAtleast = false
        
    }
    
    func showLoader()
    {
        
    }
    
    func hideLoader(){
        
    }
    
    func checkIfThereIsAnyFileThatExistsOnDeviceAndReturnArrayOfSheets()->NSMutableArray{
        return NSMutableArray()
    }
    
    
    func didFinishParsing(with dictionary: NSMutableDictionary!) {
        self.sheetsData?.add(dictionary)
    }
    

    func setupWithAccessKey(_accessKey:String!, andSecretKey _secretKey:String!, withDownloadCompletionCallBack downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) {
        
         self.sheetsData = NSMutableArray()

         showLoader()
        
        self.listAllKeysFromServer { handler, objects in
            
            
            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            Task {
                
                await self.downloadFreshFilesFromServerWithAccessKey(handler: handler, _accessKey: _accessKey, andSecretKey:_secretKey, withShowAlert:true, withListOfObjects:objects, withDownloadCompletionCallBack:{ (downloadCompleted:Bool) in

                     if downloadCompleted {

                         if !self.hasComeFromAFlowWhenNoNewFilesAreThere {

                             self.hasComeFromAFlowWhenFoundSomethingAtleast = true

                             if UserSettings.shared.recentlyCreated! {

                                 let storedSheetsArray:NSMutableArray! = self.checkIfThereIsAnyFileThatExistsOnDeviceAndReturnArrayOfSheets()

                                 if (storedSheetsArray != nil) && storedSheetsArray.count>0 {

                                     // Check if Any sheet is not Completed or Voided then sync it back to the server
                                     
                                     for obj in storedSheetsArray {
                                         self.sheetsData?.add(obj)
                                     }
                                     
                                 }

                                 if Utilities.sharedInstance.isNetworkStatusAvailable() {
                                     self.sheetsData?.write(toFile: PlistManager.sharedInstance.getPlistFilePathForCurrentSettings(), atomically:true)
                                 }
                             }

                             DispatchQueue.main.async {
                                 
                                 if UserSettings.shared.recentlyCreated! {
                                     
                                     UserSettings.shared.recentlyCreated = false
                                     
                                     self.setPlistSheetDetailArrayWithNewData(newPlistSheetDetailArray: self.sheetsData)
                                     
                                     self.hideLoader()
                                     
                                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlistSyncedWithServer"), object: nil)

                                 }
                             }
                         }else{

                             DispatchQueue.main.async {

                                 self.hideLoader()

                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlistSyncedWithServer"), object: nil)

                             }
                         }
                         downloadCompletionCallback(true)
                     }
                 })
            }
            
            
        }
        
     }
    
    func listAllKeysFromServer(awsListAllFilesHandler: @escaping AWSS3ListFileNamesFetchingCallback){
        
        Task {
        
            let handler = await S3Handler()
            
            var fileNamesList:[String] = []
      
            do {
                
                fileNamesList = try await handler.listBucketFiles(bucket: AppConstant.bucketName)

                awsListAllFilesHandler(handler,fileNamesList) // List of files
                
            } catch {
                
                print("Show some alert here")
                
                awsListAllFilesHandler(handler,[]) // Empty list
                
//                TODO: LOKESH SEHGAL showAlertOnInvalidAccessKeyAndSecretKey
                    
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.PlistSyncedWithServerFailure), object: nil)
                
                return
        
                
            }
        }
    }
    
    
    func downloadFreshFilesFromServerWithAccessKey(handler:S3Handler, _accessKey:String!, andSecretKey _secretKey:String!, withShowAlert showAlert:Bool, withListOfObjects fileNamesList:[String], withDownloadCompletionCallBack downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) async {

        Utilities.sharedInstance.createFolderInDocumentDirectoryWithPath(folderPath: PlistManager.sharedInstance.getPlistFilePathForCurrentSettings().stringByDeletingLastPathComponent)

        tempCurrentFreshSheetCount = 0

        if (self.sheetsData == nil)
            {self.sheetsData = NSMutableArray()}

        let totalFreshSheetsToBeDownloaded:NSMutableArray! = self.getTotalCountOfFreshSheetsFromSummaryArray(summaries: fileNamesList)

        if (totalFreshSheetsToBeDownloaded != nil) && totalFreshSheetsToBeDownloaded.count > 0
        {
            DispatchQueue.main.async {
                let sheetsNotificationModel = self.getSheetSyncModelWithSyncType(syncType: AppConstant.SyncType.DOWNLOAD, currentCount:self.tempCurrentFreshSheetCount!, totalCount:totalFreshSheetsToBeDownloaded.count)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.HomeScreenSyncInProcessNotification), object: sheetsNotificationModel)
            }
        }

        if (totalFreshSheetsToBeDownloaded != nil) {

            DispatchQueue.main.async {
                self.hideLoader()
            }

            
            let dispatchQueue = DispatchQueue(label: "BackgroundQueueToDownloadFiles", qos: .background)

            dispatchQueue.async {
                
                self.downloadedContentWithShowAlert(handler: handler,fileNamesList: fileNamesList, showAlert: showAlert, withObjectsArray:totalFreshSheetsToBeDownloaded,  withDownloadCompletionCallBack:downloadCompletionCallback)
            }
            
        }
    }
    
    
    /**    @function    :getTotalCountOfFreshSheetsFromSummaryArray:
     @discussion    :It will check for total fresh sheets from summaries array
     @param            :summaries: Contains S3ObjectSummary objects
     @return        :int: total count of fresh sheets.
     */
    func getTotalCountOfFreshSheetsFromSummaryArray(summaries: [String]) -> NSMutableArray! {
        let freshSheets:NSMutableArray! = NSMutableArray()

        let selectedChannel:String! = UserSettings.shared.selectedChannel

        for key in summaries {

            let componentArray:[String]! = key.components(separatedBy: "_")

            if Utilities.sharedInstance.checkStringContainsText(text: selectedChannel)
            {
                if componentArray.count < 3
                    {continue}

                let serialNumber:String! = componentArray.first
                let channel:String! = componentArray[1].replace(target: "-", withString: "")

                if !(serialNumber == UserSettings.shared.serialKey)
                    {continue}

                if !(channel == selectedChannel)
                    {continue}
            }
            else
            {
                if componentArray.count > 0
                {
                    if !(componentArray.first == UserSettings.shared.serialKey)
                        {continue}
                }
            }

            let status = key.lastLetter()

            if (status == AppConstant.status_fresh)
            {
                freshSheets.add(key)
            }
         }

        return freshSheets
    }
    
    
    func getSheetSyncModelWithSyncType(syncType:AppConstant.SyncType, currentCount:Int, totalCount:Int) -> SheetSyncNotificationModel {
        return SheetSyncNotificationModel(syncType: syncType, currentCount: currentCount, totalCount: totalCount)
    }
    
    func downloadedContentWithShowAlert(handler: S3Handler, fileNamesList:[String], showAlert:Bool, withObjectsArray totalFreshSheetsToBeDownloaded:NSMutableArray!, withDownloadCompletionCallBack downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) {
        
        Task {
                        
                    let totalFreshSheets:Int = totalFreshSheetsToBeDownloaded.count

                    var totalNumberOfObjects:Int = totalFreshSheetsToBeDownloaded.count

                    for sheetName in totalFreshSheetsToBeDownloaded {

                         totalNumberOfObjects -= 1
                         
                           var fileData:Data
                           var fileName = ""
                         
                           do {
                               fileName = sheetName as! String
                               
                               fileData = try await handler.readFile(bucket: AppConstant.bucketName, key: fileName)
                               
                           } catch {
                               
                               print("Show some alert here")
                                   
                               NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.PlistSyncedWithServerFailure), object: nil)
                               
                               downloadCompletionCallback(true)
                               
                               self.allFilesCompletelyDownloadedWithDownloadCompletionCallBack(downloadCompletionCallback: downloadCompletionCallback)
                               
                               return
                           }
                         
                         
                         if !fileData.isEmpty && fileData.count > 0 {

                             let parser:SheetParser! = SheetParser(delegate:self, data:fileData)
        
                             parser.filename = fileName
                             
                             parser.parse()
        
                             self.tempCurrentFreshSheetCount! += 1
        
                             DispatchQueue.main.async {

                                 let sheetsNotificationModel = self.getSheetSyncModelWithSyncType(syncType: AppConstant.SyncType.DOWNLOAD, currentCount:self.tempCurrentFreshSheetCount!, totalCount:totalFreshSheets)
                                 
                                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.HomeScreenSyncInProcessNotification), object: sheetsNotificationModel)
                             }
                             
                             DispatchQueue.main.sync
                             {
                                 if self.isSheetAlreadyPresent(fileName: fileName)
                                 {
                                     self.removeSheetFromCurrentPlistWithFileName(fileName: fileName)
                                 }
                             }


                             self.deleteFileWithKey(handler: handler, fileName: fileName)   // Delete fresh file from server after downloading.

                             if totalNumberOfObjects==0 {
                                 self.allFilesCompletelyDownloadedWithDownloadCompletionCallBack(downloadCompletionCallback: downloadCompletionCallback)
                             }
                         }


                      }

                         if (totalFreshSheetsToBeDownloaded != nil) && totalFreshSheetsToBeDownloaded.count==0 {
                                 self.hasComeFromAFlowWhenNoNewFilesAreThere = true
                                 downloadCompletionCallback(true)
                         }

        }
      }
    
    func deleteFileWithKey(handler: S3Handler, fileName:String){
        
        Task {
            
            do {
                
                try await handler.deleteFile(bucket: AppConstant.bucketName, key: fileName)
                
                print("file deleted from s3")
                
            } catch {
                
                print("Failed to delete from s3")
                    
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.PlistSyncedWithServerFailure), object: nil)
                
                return
        
                
            }
        }
    }
    
    
    func allFilesCompletelyDownloadedWithDownloadCompletionCallBack(downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) {

        if (self.sheetsData != nil) {
//            let tempMutableData:NSMutableArray! = CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (self.sheetsData as! CFArrayRef), kCFPropertyListMutableContainersAndLeaves)
//
//            if self.sheetsData
//                {self.sheetsData = nil}
//
//            self.sheetsData = tempMutableData
//
//            CFRelease(tempMutableData)
//
             tempCurrentFreshSheetCount = 0
//
//            dispatch_async(dispatch_get_main_queue(), {
//                let appDelegate:AppDelegate! = UIApplication.sharedApplication().delegate()
//                appDelegate.hideLoader()
//            })

            downloadCompletionCallback(true)
        }
    }
    
    func isSheetAlreadyPresent(fileName:String!) -> Bool {
        
        if !Utilities.sharedInstance.checkStringContainsText(text: fileName)
            {return false}

        let plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
        
        guard let plistArray = plistSheetDetailArray else {
            return false
        }
        
        for sheetDic in plistArray {
           
            let sheetObj = sheetDic as! NSDictionary

            if let afileName = sheetObj[AppConstant.sheet_file_name] as? String {
                if (afileName == fileName){
                    return true
                }
            }
         }


        return false
    }
    
    
    /**    @function    :removeSheetFromCurrentPlistWithFileName:
     @discussion    :It will remove the dic from sheets array with the filename.
     @param            :fileName: contains the filename of the sheet.
     @return        :-
     */
    func removeSheetFromCurrentPlistWithFileName(fileName:String!) {
        if !Utilities.sharedInstance.checkStringContainsText(text: fileName)
            {return}

        let plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
        
        guard plistSheetDetailArray != nil else {
            return
        }
        
        for sheetDic in plistSheetDetailArray {
           
            let sheetObj = sheetDic as! NSDictionary

            if let afileName = sheetObj[AppConstant.sheet_file_name] as? String {
                if (afileName == fileName){
                    plistSheetDetailArray.remove(sheetObj)
                    break
                }
            }
         }
    }
    
    func uploadFilesAccordingToStatus() async{
        
        let totalCompleteSheets = self.getTotalCountOfCompleteSheets()
        
        if(totalCompleteSheets > 0) {

            DispatchQueue.main.async {
                let sheetsNotificationModel = self.getSheetSyncModelWithSyncType(syncType: AppConstant.SyncType.UPLOAD, currentCount:0, totalCount:totalCompleteSheets)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.HomeScreenSyncInProcessNotification), object: sheetsNotificationModel)
            }
        }
                
        DispatchQueue.main.async {
            self.showLoader()
        }
                
        self.listAllKeysFromServer { handler, objects in
            
                var plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
                
                if let plistArray = plistSheetDetailArray {
                                                    
                    var currentCompleteSheet:Int = 0
                    var iIndex = 0

                    for sheetDic in plistSheetDetailArray {
                       
                        let sheetData = sheetDic as! NSDictionary

                        if let fileName = sheetData[AppConstant.sheet_file_name] as? String {
                            
                            let status = fileName.lastLetter()
                            
                            if (status == AppConstant.status_draft || status == AppConstant.status_fresh){
                                continue
                            }
                            
                            let fileNameWithoutExtension:String! = fileName.stringByDeletingPathExtension
                            
                            for fileName in objects {
                                
                                let fileNameAtServerWithoutExtension = fileName.stringByDeletingPathExtension
                                
                                if (fileNameAtServerWithoutExtension == fileNameWithoutExtension){
                                    
                                    if (status == AppConstant.status_void){
                                        
                                        self.deleteFileWithKey(handler: handler, fileName: fileName)
                                        
                                    }else if (status == AppConstant.status_complete){
                                        
                                        let statusOnServer = fileName.lastLetter()
                                        
                                        if (statusOnServer == AppConstant.status_fresh) {
                                            self.deleteFileWithKey(handler: handler, fileName: fileName)
                                        }
                                        
                                    }
                                    
                                }
                                
                            } // End of inner loop
                            
                            if(status == AppConstant.status_void){
                                plistSheetDetailArray.removeObject(at: iIndex)
                                // TODO: LOKESH SEHGAL - MOVE TO ARCHIVE
                                iIndex = -1
                            }
                            else if(status == AppConstant.status_complete){
                                
                                
                                let hasPutFileOnServer:Bool = self.putFileOnServerWithKey(handler: handler, key: fileName, andDataDic:plistSheetDetailArray.object(at: iIndex) as! NSMutableDictionary)

    //                             if hasPutFileOnServer {
                                // TODO: LOKESH SEHGAL - MOVE TO ARCHIVE
    //                                 self.moveDataToArchiveSheetWithIndex(i)
    //                             }
                                
                                plistSheetDetailArray.removeObject(at: iIndex)

                                iIndex -= 1

                                currentCompleteSheet += 1
                                
                                DispatchQueue.main.async {
                                    let sheetsNotificationModel = self.getSheetSyncModelWithSyncType(syncType: AppConstant.SyncType.UPLOAD, currentCount:currentCompleteSheet, totalCount:totalCompleteSheets)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.HomeScreenSyncInProcessNotification), object: sheetsNotificationModel)
                                }

                            }
                        }
                        
                        iIndex += 1
                     }
                    
                    self.downloadFilesFromServerAndInsertInPlistDetailArray(handler: handler, listOfKeysAtServer: objects)
                }
                
                
        }
        
    }
    
    func downloadFilesFromServerAndInsertInPlistDetailArray(handler: S3Handler, listOfKeysAtServer:[String]!) {
        
        Task {
            await self.downloadFreshFilesFromServerWithAccessKey(handler: handler, _accessKey: self.accessKey, andSecretKey:self.secretKey, withShowAlert:false, withListOfObjects:listOfKeysAtServer, withDownloadCompletionCallBack:{ (downloadCompleted:Bool) in
            
            //        if(hasComeFromAFlowWhenFoundSomethingAtleast){
            
            let plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
            
            guard let plistArray = plistSheetDetailArray else {
                return
            }
            
                let aPlistSheetsArray = NSMutableArray(array: plistArray)
            
                if (aPlistSheetsArray != nil) && aPlistSheetsArray.count>0 && (self.sheetsData != nil) && self.sheetsData!.count > 0 {
                
                let temporaryArray:NSMutableArray! = NSMutableArray()
                
                for downloadedSheet in self.sheetsData! {
                    
                    var hasEntryFound:Bool = false
                    
                    for sheetDic in aPlistSheetsArray {
                        
                        let sheetObj = sheetDic as! NSDictionary
                        
                        let downloadedSheetName:String! = (sheetObj.object(forKey: AppConstant.sheet) as! NSDictionary).value(forKey: AppConstant.sheet_name) as? String
                        
                        let plistSheet = downloadedSheet as! NSDictionary
                        
                        let plistSheetName:String! = (plistSheet.object(forKey: AppConstant.sheet) as! NSDictionary).value(forKey: AppConstant.sheet_name) as? String
                        
                        if (downloadedSheetName != nil) && (plistSheetName != nil) && (plistSheetName == downloadedSheetName) {
                            hasEntryFound = true
                        }
                    }
                    
                    if !hasEntryFound {
                        temporaryArray.add(downloadedSheet)
                    }
                }
                
                for tempArr in temporaryArray {
                    plistSheetDetailArray.add(tempArr)
                }
                
            }else if (plistSheetDetailArray != nil) && plistSheetDetailArray.count==0 {
                for tempArr in self.sheetsData! {
                    plistSheetDetailArray.add(tempArr)
                }
            }
            
            if Utilities.sharedInstance.isNetworkStatusAvailable() {
                plistSheetDetailArray.write(toFile: PlistManager.sharedInstance.getPlistFilePathForCurrentSettings(), atomically: true)
                
                self.setPlistSheetDetailArrayWithNewData(newPlistSheetDetailArray: plistSheetDetailArray)
                
            }
            
            //        }
            
            self.hasComeFromAFlowWhenNoNewFilesAreThere = false
            self.hasComeFromAFlowWhenFoundSomethingAtleast = false
            
            DispatchQueue.main.async {
                self.hideLoader()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlistSyncedWithServer"), object: nil)
            }
            
        })
        
    }
    }
    
    func setPlistSheetDetailArrayWithNewData(newPlistSheetDetailArray:NSMutableArray!) {
        
        DispatchQueue.main.async {
            
            var plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
            
            guard plistSheetDetailArray != nil else {
                return
            }
            
            plistSheetDetailArray.removeAllObjects()
          
            plistSheetDetailArray = nil
            
            SharedDelegate.sharedInstance.plistSheetDetailArray = newPlistSheetDetailArray
          
        }
        
    }
    
    
    func putFileOnServerWithKey(handler:S3Handler, key:String!, andDataDic sheetDataDic:NSMutableDictionary!) -> Bool {
          // Put the file as an object in the bucket.

          let gen:XMLGenerator! = XMLGenerator()

          var hasPutFileOnServer:Bool = false

          gen.sheet = sheetDataDic as? [AnyHashable : Any]

          let xml:String! = gen.getXMLString()

          let xmlData:Data! = xml.data(using: .utf8)

          let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        
          let filePathUrl:String! = cacheDirectoryPath?.stringByAppendingPathComponent(path: key)

            do {
                try xmlData.write(to: URL(fileURLWithPath: filePathUrl))
                
            }catch{
                print("FILE not SAVED")
                return false
            }
        
          if FileManager.default.fileExists(atPath: filePathUrl) == false{
              print("FILE not SAVED")
              return false
          }
        
          
        do {
            
            Task {
                try await handler.uploadFile(bucket: AppConstant.bucketName, key: key, file: filePathUrl)
            }

            NSLog("uploaded succeesfully")
            
            hasPutFileOnServer = true
            
            try FileManager.default.removeItem(atPath: filePathUrl)
            
        } catch {
            
            print("Show some alert here")
            
            hasPutFileOnServer = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.PlistSyncedWithServerFailure), object: nil)
            
        }
        
         

          return hasPutFileOnServer
      }
    
    /**    @function    :getTotalCountOfCompleteSheets
     @discussion    :It will check for total complete sheets
     @param            :-
     @return        :int: total count of complete sheets.
     */
        func getTotalCountOfCompleteSheets() -> Int {
            
            var completeSheets:Int = 0
            
            let plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
            
            guard let plistArray = plistSheetDetailArray else {
                return completeSheets
            }

            for sheetDic in plistArray {
               
                let sheetObj = sheetDic as! NSDictionary

                if let fileName = sheetObj[AppConstant.sheet_file_name] as? String {
                   
                    let status = fileName.lastLetter()
                    
                    if status == AppConstant.status_complete {
                        completeSheets += 1
                    }
                    
                }
             }

            return completeSheets
        }
    
    func allFilesCompletelyDownloadedWithFailureDownloadCompletionCallBack(downloadCompletionCallback:AWSS3DownloadCompletionCallback) {

        if let array = self.sheetsData {

            tempCurrentFreshSheetCount = 0

            downloadCompletionCallback(true)
        }
    }
    
    // TODO: LOKESH SEHGAL
    // I NEED TO WORK ON IMPLEMENTING THE BELOW METHODS FOR ARCHIVING FEATURE AND FIX THE USAGE
    // 1. moveDataToArchiveSheetWithIndex
    
    func showAlertOnInvalidAccessKeyAndSecretKey(){
//        let alertController = UIAlertController(title: "ShoWorks", message: "some error message", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true)
    }
    
    func searchTextAndFindModels(aSearchedText:String,sheetsViewModel:SheetsViewModel){
        
        searchedRecords = []
        
        // refreshing the array
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationRefreshLayoutOnSearch), object: false)
        
        // This logic is entirely for Kiosk
        
        if Utilities.sharedInstance.checkStringContainsText(text: aSearchedText){
            
//            if let arrayOfSheets = sheetsViewModel.arrayOfSheets {
                
//                for sheetsDictionary in arrayOfSheets {
                    
//                    sheetsViewModel.selectedDictionary = sheetsDictionary as? NSDictionary
                                        
                    if let dictionary = sheetsViewModel.selectedDictionary {
                        
                        var isKiosk = false

                        if SheetUtility.sharedInstance.isKioskModeEnabledInSheet(sheetDic: dictionary){
                            isKiosk = true
                        }else{
                            isKiosk = false
                        }
                        
                        if isKiosk {
                            
                              if let array = SearchingUtility.searchManualEntry(aSearchedText, inSheetDic: dictionary as! NSMutableDictionary){
                              
                                  for model in array {
                                  
                                      let customSearchModel = model as! SearchDataModel
                                      
                                      if customSearchModel.searchedEntryIdArray.count > 0 {

                                          let searchedEntryID:String = customSearchModel.searchedEntryIdArray[0] as! String

                                          let dictionary = customSearchModel.classDetailDic as NSDictionary

                                          if let array:NSMutableArray = dictionary.object(forKey: AppConstant.sheet_entries) as? NSMutableArray {
                                             
                                              for object in array {
                                                  let rowDictionary = object as! NSDictionary
                                                  
                                                  if let attributeDictionary = rowDictionary[AppConstant.sheet_attributes] as? NSDictionary {
                                                      
                                                      let entryID:String = attributeDictionary.value(forKey: AppConstant.sheet_entry_id) as! String
                                                      
                                                      if Int(searchedEntryID) == Int(entryID) {
                                                          
                                                          let exhibitorName:String = attributeDictionary.value(forKey: AppConstant.sheet_exhibitor) as! String
                                                          
                                                          let columnsArray:NSMutableArray = rowDictionary[AppConstant.sheet_columns] as! NSMutableArray
                                                          
                                                          let wenNumber:String = attributeDictionary.value(forKey: AppConstant.sheet_wen) as! String
                                                          
                                                          if columnsArray.count == 8 {
                                                              
                                                              let allowed = columnsArray[6] as! String
                                                              
                                                              let entry = Entry(exhibitor: exhibitorName, department: customSearchModel.departmentName, club: columnsArray[2] as! String, entryNumber: entryID, wen: wenNumber, division: customSearchModel.divisionName, Class: customSearchModel.className, description: columnsArray[1] as! String, validationNumber: columnsArray[3] as! String, entryValidationDate: columnsArray[4] as! String, stateFair: columnsArray[5] as! String, salePrice: columnsArray[7] as! String,isAllowedForSale: (allowed == "No" ? true : false))
                                                              
                                                              searchedRecords.append(entry)
                                                              
                                                          }
                                                          break
                                                      }
                                                      
                                                  }
                                              }

                                          }
                                          
                                          
                                      }
                                  }
                              }
                        }else{
                            
                                  var loadSearchModelsArray = NSMutableArray()
                                
                                  SearchingUtility.getSearchModels(fromSearchText: aSearchedText, inSheetDic: dictionary as! NSMutableDictionary, inSearchModelArray: loadSearchModelsArray)
                            
                                  for model in loadSearchModelsArray {
                                  
                                      let customSearchModel = model as! SearchDataModel
                                      
                                      if customSearchModel.searchedEntryIdArray.count > 0 {

                                          let searchedEntryID:String = customSearchModel.searchedEntryIdArray[0] as! String

                                          let dictionary = customSearchModel.classDetailDic as NSDictionary

                                          if let array:NSMutableArray = dictionary.object(forKey: AppConstant.sheet_entries) as? NSMutableArray {
                                             
                                              for object in array {
                                                  let rowDictionary = object as! NSDictionary
                                                  
                                                  if let attributeDictionary = rowDictionary[AppConstant.sheet_attributes] as? NSDictionary {
                                                      
                                                      let entryID:String = attributeDictionary.value(forKey: AppConstant.sheet_entry_id) as! String
                                                      
                                                      if Int(searchedEntryID) == Int(entryID) {
                                                          
//                                                          let exhibitorName:String = attributeDictionary.value(forKey: AppConstant.sheet_exhibitor) as! String
//                                                          
//                                                          let columnsArray:NSMutableArray = rowDictionary[AppConstant.sheet_columns] as! NSMutableArray
//                                                          
//                                                          let wenNumber:String = attributeDictionary.value(forKey: AppConstant.sheet_wen) as! String
                                                          
//                                                          if columnsArray.count == 8 {
                                                              
//                                                              let allowed = columnsArray[6] as! String
//                                                              
//                                                              let entry = Entry(exhibitor: "John Doe|Calvert, TX", department: customSearchModel.departmentName, club: "S.B. Ms Cadence 54J26|Brangus|KRINSKY CLUB LAMBS 10-15", entryNumber: entryID, wen: "609A7A", division: customSearchModel.divisionName, Class: customSearchModel.className, description: "Test", validationNumber: "23829389723", entryValidationDate: "12/23/2011", stateFair: columnsArray[5] as! String, salePrice: columnsArray[7] as! String,isAllowedForSale: (allowed == "No" ? true : false))
//                                                              
//                                                              searchedRecords.append(entry)
                                                              
//                                                          }
                                                          break
                                                      }
                                                      
                                                  }
                                              }

                                          }
                                          
                                          
                                      }
                                  }
                        }
                      
                    }
                    
                    
                    
//                }
//            }
            
            
        }
//        
//        
//        //// This Logic is entirely for Non-Kiosk (Home and Hobby sort of )
//        ///
//    
//        if Utilities.sharedInstance.checkStringContainsText(text: aSearchedText){
//
//            if let dictionary = kioskViewModel.selectedDictionary {
//                
//                var searchDataModelArray = NSMutableArray()
//                
//                SearchingUtility.getSearchModels(fromSearchText: aSearchedText, inSheetDic: kioskViewModel.selectedDictionary as! NSMutableDictionary, inSearchModelArray: searchDataModelArray)
//                
//                if searchDataModelArray != nil && searchDataModelArray.count > 0{
//                
//                    for model in searchDataModelArray {
//                    
//                        let customSearchModel = model as! SearchDataModel
//                        
//                        if customSearchModel.searchedEntryIdArray.count > 0 {
//
//                            let searchedEntryID:String = customSearchModel.searchedEntryIdArray[0] as! String
//
//                            let dictionary = customSearchModel.classDetailDic as NSDictionary
//
//                            if let array:NSMutableArray = dictionary.object(forKey: AppConstant.sheet_entries) as? NSMutableArray {
//                               
//                                for object in array {
//                                    let rowDictionary = object as! NSDictionary
//                                    
//                                    if let attributeDictionary = rowDictionary[AppConstant.sheet_attributes] as? NSDictionary {
//                                        
//                                        let entryID:String = attributeDictionary.value(forKey: AppConstant.sheet_entry_id) as! String
//                                        
//                                        if Int(searchedEntryID) == Int(entryID) {
//                                            
//                                            let columnsArray:NSMutableArray = rowDictionary[AppConstant.sheet_columns] as! NSMutableArray
//                                            
//                                            let wenNumber:String = attributeDictionary.value(forKey: AppConstant.sheet_wen) as! String
//                                            
//                                            if columnsArray.count == 7 {
//                                                
////                                                let allowed = columnsArray[6] as! String
////
////                                                let exhibitorName:String = attributeDictionary.value(forKey: AppConstant.sheet_exhibitor) as! String
////
//                                                let entry = Entry(exhibitor: columnsArray[1] as! String, department: customSearchModel.departmentName, club: columnsArray[3] as! String, entryNumber: entryID, wen: wenNumber, division: customSearchModel.divisionName, Class: customSearchModel.className, description: columnsArray[4] as! String, validationNumber: "", entryValidationDate: "", stateFair: "", salePrice: "",isAllowedForSale: false)
//                                                
//                                                searchedRecords.append(entry)
//                                                
//                                            }
//                                            break
//                                        }
//                                        
//                                    }
//                                }
//
//                            }
//                            
//                            
//                        }
////                        print("==================")
////                        print(customSearchModel.classDetailDic)
////                        print("<><><><><><><><>")
////                        print(customSearchModel.searchedEntryIdArray)
////                        print("*****************")
////                        var entry = Entry(exhibitor: customSearchModel., department: <#T##String#>, club: <#T##String#>, entryNumber: <#T##String#>, wen: <#T##String#>, division: <#T##String#>, Class: <#T##String#>, description: <#T##String#>, validationNumber: <#T##String#>, entryValidationDate: <#T##String#>, stateFair: <#T##String#>, salePrice: <#T##String#>)
//                    }
//                }
//            }
//            
//        }
//        
        
        
        
        /*
         for Demo mode - hardcoded model for testing
         
         
            searchedRecords  = [
                .init(exhibitor: "Coulter Michaels", department: "Home & Hobby", club: "French Valley 4H", entryNumber: "5948", wen: "C2FB04", division: "203 - Drawing", Class: "04 - Oil - Representational", description: "Mary's Orchids", validationNumber: "671858728", entryValidationDate: "09/28/2012", stateFair: "I will take to state fair", salePrice: "218.99",isAllowedForSale: true)
            ]
         
         */
        
        var isSearchedRecordsContainsData = false
        
        if searchedRecords.count == 0 {
            isSearchedRecordsContainsData = false
        }else{
            isSearchedRecordsContainsData = true
        }
                
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationWhenSearchedRecordChanges), object: isSearchedRecordsContainsData)
    }
    
    // Loading the layout with empty data
    func refreshViewWithEmptyLayout(){
      
        searchedRecords = []
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationRefreshLayoutOnSearch), object: false)
                
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationWhenSearchedRecordChanges), object: false)
    }
}
