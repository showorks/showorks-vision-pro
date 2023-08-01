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
typealias AWSS3DownloadCompletionCallback = (_ downloadCompleted: Bool) -> Void

class DataCenter : NSObject,SheetParserDelegate {
    
    static let sharedInstance = DataCenter()
        
    var tempCurrentFreshSheetCount:Int?
    
    var hasComeFromAFlowWhenNoNewFilesAreThere:Bool

    var hasComeFromAFlowWhenFoundSomethingAtleast:Bool
    
    var accessKey:String?
    
    var secretKey:String?
    
    var currentSheetKey:String?

    var sheetsData: NSMutableArray?
    
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
        
        self.getListOfKeysFromServer(awsS3ObjectsFetchingCallback: { (objects:NSMutableArray!) in

            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            Task {
                
                await self.downloadFreshFilesFromServerWithAccessKey(_accessKey: _accessKey, andSecretKey:_secretKey, withShowAlert:true, withListOfObjects:objects, withDownloadCompletionCallBack:{ (downloadCompleted:Bool) in

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

    //                                 NSNotificationCenter.defaultCenter().postNotificationName("PlistSyncedWithServer", object:nil)

                                 }
                             }
                         }else{

                             DispatchQueue.main.async {

                                 self.hideLoader()

    //                             NSNotificationCenter.defaultCenter().postNotificationName("PlistSyncedWithServer", object:nil)

                             }
                         }
                         downloadCompletionCallback(true)
                     }
                 })
            }
            

         })


     }
    
    func setPlistSheetDetailArrayWithNewData(newPlistSheetDetailArray:NSMutableArray!) {
//        dispatch_async(dispatch_get_main_queue(), {
//            let appDelegate:AppDelegate! = UIApplication.sharedApplication().delegate()
//            if appDelegate.plistSheetDetailArray()
//            {
//                if appDelegate.plistSheetDetailArray().count() > 0
//                {
//                    appDelegate.plistSheetDetailArray().removeAllObjects()
//                    appDelegate.plistSheetDetailArray = nil
//                }
//            }
//
//            appDelegate.plistSheetDetailArray = newPlistSheetDetailArray
//
//        })
    }
    
    func getListOfKeysFromServer(awsS3ObjectsFetchingCallback:AWSS3ObjectsFetchingCallback) {
        
        awsS3ObjectsFetchingCallback(NSMutableArray())
        
//           let getListObjectsRequest:AWSS3ListObjectsRequest! = AWSS3ListObjectsRequest()
//        
//        
//
//           getListObjectsRequest.bucket = BUCKET_NAME
//
//           AWSS3.defaultS3().listObjects(getListObjectsRequest).continueWithBlock({ (listAllObjects:BFTask!) in
//
//               if listAllObjects.error
//               {
//                   NSLog("listAllObjects Error: %@",listAllObjects.error)
//                   dispatch_async(dispatch_get_main_queue(), {
//                       self.showAlertOnInvalidAccessKeyAndSecretKey()
//                       let appDelegate:AppDelegate! = UIApplication.sharedApplication().delegate()
//                       appDelegate.hideLoader()
//
//                       NSNotificationCenter.defaultCenter().postNotificationName(PlistSyncedWithServerFailure, object:nil)
//                       awsS3ObjectsFetchingCallback(nil)
//                   })
//               }
//               else
//               {
//                   dispatch_async(dispatch_get_main_queue(), {
//                       awsS3ObjectsFetchingCallback(listAllObjects.result.contents().mutableCopy())
//                   })
//               }
//
//               return nil
//           })
       }
    
    
    func downloadFreshFilesFromServerWithAccessKey(_accessKey:String!, andSecretKey _secretKey:String!, withShowAlert showAlert:Bool, withListOfObjects listedObjects:NSMutableArray!, withDownloadCompletionCallBack downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) async {

        Utilities.sharedInstance.createFolderInDocumentDirectoryWithPath(folderPath: PlistManager.sharedInstance.getPlistFilePathForCurrentSettings().stringByDeletingLastPathComponent)

        tempCurrentFreshSheetCount = 0

        if (self.sheetsData == nil)
            {self.sheetsData = NSMutableArray()}


        var handler = await S3Handler()
        
        var fileNamesList:[String] = []
  
        do {
            
            fileNamesList = try await handler.listBucketFiles(bucket: AppConstant.bucketName)

        } catch {
            print("ERROR: ", dump(error, name: "Initializing S3 client"))
            exit(1)
        }
        
        if fileNamesList.count == 0 {
// Handle error here
//
//            if listTask.error
//            {
//                NSLog("listTask Error: %@",listTask.error)
//                if showAlert
//                {
//                    var rootViewController:AnyObject! = UIApplication.sharedApplication().delegate.window.rootViewController
//
//                    if (rootViewController is UINavigationController)
//                    {
//                        if (rootViewController is UINavigationController)
//                        {
//                            for viewController:UIViewController! in (rootViewController as! UINavigationController).viewControllers {
//                                if (viewController.dynamicType is HomeScreenViewController) {
//                                    rootViewController = viewController
//                                    break
//                                }
//                             }
//
//                            if rootViewController==nil
//                                {rootViewController = (rootViewController as! UINavigationController).viewControllers.firstObject}
//                        }
//                    }
//
//                }
//
//                NSNotificationCenter.defaultCenter().postNotificationName(PlistSyncedWithServerFailure, object:nil)
//                return
//
//            }
//            else
//            {
//                let outPut:AWSS3ListObjectsOutput! = listTask.result
//                summaries =  outPut.contents()
//            }

        }

        let totalFreshSheetsToBeDownloaded:NSMutableArray! = self.getTotalCountOfFreshSheetsFromSummaryArray(summaries: fileNamesList)

        if (totalFreshSheetsToBeDownloaded != nil) && totalFreshSheetsToBeDownloaded.count > 0
        {
            let sheetsNotificationModel = self.getSheetSyncModelWithSyncType(syncType: AppConstant.SyncType.DOWNLOAD, currentCount:self.tempCurrentFreshSheetCount!, totalCount:totalFreshSheetsToBeDownloaded.count)
//            NotificationCenter.default.post(name: AppConstant.HomeScreenSyncInProcessNotification, object: sheetsNotificationModel)
//            NSNotificationCenter.defaultCenter().postNotificationName(HomeScreenSyncInProcessNotification, object:))
        }

        if (totalFreshSheetsToBeDownloaded != nil) {

            DispatchQueue.main.async {
                self.hideLoader()
            }

            
            let dispatchQueue = DispatchQueue(label: "BackgroundQueueToDownloadFiles", qos: .background)

            dispatchQueue.async {
                
                self.downloadedContentWithShowAlert(showAlert: showAlert, withObjectsArray:totalFreshSheetsToBeDownloaded,  withDownloadCompletionCallBack:downloadCompletionCallback)
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
    
    func downloadedContentWithShowAlert(showAlert:Bool, withObjectsArray totalFreshSheetsToBeDownloaded:NSMutableArray!, withDownloadCompletionCallBack downloadCompletionCallback: @escaping AWSS3DownloadCompletionCallback) {
        
        Task {
                        
                    var handler = await S3Handler()
                    
                    var fileNamesList:[String] = []
                          
                    var totalFreshSheets:Int = totalFreshSheetsToBeDownloaded.count

                    var totalNumberOfObjects:Int = totalFreshSheetsToBeDownloaded.count

                     for sheetName in totalFreshSheetsToBeDownloaded {

                         totalNumberOfObjects -= 1
                         
                           var fileData:Data
                           var fileName = ""
                         
                           do {
                               fileName = sheetName as! String
                               
                               fileData = try await handler.readFile(bucket: AppConstant.bucketName, key: fileName)
                               
                           } catch {
                               print("ERROR: ", dump(error, name: "Initializing S3 client"))
                               exit(1)
                           }
                         
                         
                         if !fileData.isEmpty && fileData.count > 0 {

                             let parser:SheetParser! = SheetParser(delegate:self, data:fileData)
        
                             parser.filename = fileName
                             
                             parser.parse()
        
                             self.tempCurrentFreshSheetCount! += 1
        
                             DispatchQueue.main.async {
//                                 NSNotificationCenter.defaultCenter().postNotificationName(HomeScreenSyncInProcessNotification, object:self.getSheetSyncModelWithSyncType(DOWNLOAD, currentCount:tempCurrentFreshSheetCount, totalCount:totalFreshSheets))
                             }
                             
//                             DispatchQueue.main.sync
//                             {
//                                 if self.isSheetAlreadyPresent(fileName: fileName)
//                                 {
//                                     self.removeSheetFromCurrentPlistWithFileName(fileName: fileName)
//                                 }
//                             }

//
//                     self.deleteFileWithKey(key)   // Delete fresh file from server after downloading.
//
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

        for sheetDic in plistSheetDetailArray {
           
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

        var plistSheetDetailArray:NSMutableArray! =  SharedDelegate.sharedInstance.plistSheetDetailArray
        
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
}
