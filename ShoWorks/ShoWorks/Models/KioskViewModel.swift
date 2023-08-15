//
//  KioskViewModel.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import Foundation
import SwiftUI

final class KioskViewModel: ObservableObject {
    
    @Published var homeViewSelectedData: HomeViewData?
    
    @Published var selectedDictionary: NSDictionary?
    
    init(homeViewSelectedData: HomeViewData? = nil, selectedDictionary: NSDictionary? = nil) {
        self.homeViewSelectedData = homeViewSelectedData
        self.selectedDictionary = selectedDictionary
    }
}
