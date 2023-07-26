//
//  HomeViewModel.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var firstWord = ""
    @Published var secondWord = ""

    
    func loadPlistArrayWithSheetsDetailData() {

        var pListArray = SharedDelegate.sharedInstance.plistSheetDetailArray
        
        if let plistSavedArray = pListArray {
            pListArray!.removeAllObjects()
        }
        
        if UserSettings.shared.isDemoUserEnabled!
        {
            SharedDelegate.sharedInstance.plistSheetDetailArray = PlistManager.sharedInstance.getPlistDataForDemoMode()
        }
        else
        {
            SharedDelegate.sharedInstance.plistSheetDetailArray = PlistManager.sharedInstance.getPlistData()
        }
        Task {
            var handler = await S3Handler()
        }
        
//        let v = SharedDelegate.sharedInstance.plistSheetDetailArray
//        print(SharedDelegate.sharedInstance.plistSheetDetailArray)
    }

}
