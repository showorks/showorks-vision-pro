//
//  SheetSyncNotificationModel.swift
//  ShoWorks
//
//  Created by Lokesh on 28/07/23.
//

import Foundation

class SheetSyncNotificationModel: NSObject {
   
    var syncType: AppConstant.SyncType
    var currentCount : Int
    var totalCount : Int

    init(syncType: AppConstant.SyncType, currentCount: Int, totalCount: Int) {
        self.syncType = syncType
        self.currentCount = currentCount
        self.totalCount = totalCount
    }
}

