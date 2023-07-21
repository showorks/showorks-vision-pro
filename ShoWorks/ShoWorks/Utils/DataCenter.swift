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

class DataCenter {

    static let sharedInstance = DataCenter()
        
    var tempCurrentFreshSheetCount:Int?
    
    var hasComeFromAFlowWhenNoNewFilesAreThere:Bool

    var hasComeFromAFlowWhenFoundSomethingAtleast:Bool
    
    var accessKey:String?
    
    var secretKey:String?
    
    var currentSheetKey:String?

    var sheetsData: NSMutableArray?
    
    /// Default initializer
    private init() {
        
        self.hasComeFromAFlowWhenNoNewFilesAreThere = false
        self.hasComeFromAFlowWhenFoundSomethingAtleast = false
        
    }
    
    func showLoader()
    {
        
    }
    
    func hideLoader(){
        
    }
    
    func isNetworkStatusAvailable()->Bool{
        return true
    }
    
    func checkIfThereIsAnyFileThatExistsOnDeviceAndReturnArrayOfSheets()->NSMutableArray{
        return NSMutableArray()
    }
    
    
    func setupWithAccessKey(_accessKey:String!, andSecretKey _secretKey:String!, withDownloadCompletionCallBack downloadCompletionCallback:AWSS3DownloadCompletionCallback) {
        
         self.sheetsData = NSMutableArray()

         showLoader()
        
        self.getListOfKeysFromServer(awsS3ObjectsFetchingCallback: { (objects:NSMutableArray!) in

            DispatchQueue.main.async {
                self.hideLoader()
            }
            
            self.downloadFreshFilesFromServerWithAccessKey(_accessKey: _accessKey, andSecretKey:_secretKey, withShowAlert:true, withListOfObjects:objects, withDownloadCompletionCallBack:{ (downloadCompleted:Bool) in

                 if downloadCompleted {

                     if !hasComeFromAFlowWhenNoNewFilesAreThere {

                         hasComeFromAFlowWhenFoundSomethingAtleast = true

                         if UserSettings.shared.recentlyCreated! {

                             let storedSheetsArray:NSMutableArray! = checkIfThereIsAnyFileThatExistsOnDeviceAndReturnArrayOfSheets()

                             if (storedSheetsArray != nil) && storedSheetsArray.count>0 {

                                 // Check if Any sheet is not Completed or Voided then sync it back to the server
//                                 self.sheetsData.addObjectsFromArray(storedSheetsArray)
                             }

                             if self.isNetworkStatusAvailable() {
//                                 self.sheetsData.writeToFile(PlistManager.getPlistFilePathForCurrentSettings(), atomically:true)
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
    
    func downloadFreshFilesFromServerWithAccessKey(_accessKey:String!, andSecretKey _secretKey:String!, withShowAlert showAlert:Bool, withListOfObjects listedObjects:NSMutableArray!, withDownloadCompletionCallBack downloadCompletionCallback:AWSS3DownloadCompletionCallback) {
//        Utility.createFolderInDocumentDirectoryWithPath(PlistManager.getPlistFilePathForCurrentSettings().stringByDeletingLastPathComponent())
//
//        tempCurrentFreshSheetCount = 0
//
//        if !self.sheetsData
//            {self.sheetsData = NSMutableArray()}
//
//
//        let getListObjectsRequest:AWSS3ListObjectsRequest! = AWSS3ListObjectsRequest()
//
//        getListObjectsRequest.bucket = BUCKET_NAME
//
//        var summaries:[AnyObject]! = nil
//
//        if listedObjects==nil {
//
//            // NEED TO FIX THIS : TODO
//            let listTask:BFTask! = AWSS3.defaultS3().listObjects(getListObjectsRequest)
//
//            listTask.waitUntilFinished()
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
//    //                [UIAlertController showAlertInViewController:rootViewController withTitle:NSLocalizedString(@"ServerNotRespondingTitle", @"") message:NSLocalizedString(@"ServerNotResponding",@"") cancelButtonTitle:NSLocalizedString(@"OkButtonText", @"") destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//    //
//    //                }];
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
//
//        }else{
//            summaries = listedObjects
//        }
//
//        let totalFreshSheetsToBeDownloaded:NSMutableArray! = self.getTotalCountOfFreshSheetsFromSummaryArray(summaries)
//
//        if (totalFreshSheetsToBeDownloaded != nil) && totalFreshSheetsToBeDownloaded.count() > 0
//            {NSNotificationCenter.defaultCenter().postNotificationName(HomeScreenSyncInProcessNotification, object:self.getSheetSyncModelWithSyncType(DOWNLOAD, currentCount:tempCurrentFreshSheetCount, totalCount:(totalFreshSheetsToBeDownloaded.count() as! int)))}
//
//        if (totalFreshSheetsToBeDownloaded != nil) {
//            dispatch_async(dispatch_get_main_queue(), {
//                let appDelegate:AppDelegate! = UIApplication.sharedApplication().delegate()
//                appDelegate.hideLoader()
//            })
//
//            self.downloadedContentWithShowAlert(showAlert, withObjectsArray:totalFreshSheetsToBeDownloaded,  withDownloadCompletionCallBack:downloadCompletionCallback)
//        }
    }
}
