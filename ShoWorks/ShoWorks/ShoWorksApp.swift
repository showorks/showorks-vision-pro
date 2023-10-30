//
//  ShoWorksApp.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI

@main
struct ShoWorksApp: App {
    
    init(){
//        navigationBarTweaks()
//        for family in UIFont.familyNames {
//             print("family:", family)
//             for font in UIFont.fontNames(forFamilyName: family) {
//                 print("font:", font)
//             }
//         }
        
        
        UserSettings.shared.roundRobinBackgroundImageIndex = UserSettings.shared.roundRobinBackgroundImageIndex! + 1
        
        if UserSettings.shared.roundRobinBackgroundImageIndex! == 3 {
            UserSettings.shared.roundRobinBackgroundImageIndex = 0
        }
        
        
    }
    var body: some Scene {
        WindowGroup {            
            SplashView()
        }.defaultSize(width: 1366, height: 824)
//        .defaultSize(width: 1, height: 0.6, depth: 0.0, in: .meters)
    }
}
