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
    
    init(homeViewSelectedData: HomeViewData? = nil, selectedDictionary: NSDictionary? = nil, arrayOfSheets : NSMutableArray? = nil) {
        self.homeViewSelectedData = homeViewSelectedData
        self.selectedDictionary = selectedDictionary
        self.arrayOfSheets = arrayOfSheets
    }
}
