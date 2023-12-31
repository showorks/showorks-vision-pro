//
//  HomeTabLayout.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 27/10/23.
//

import SwiftUI

struct HomeTabLayout: View {
  
    @Binding var isCheckIn:Bool
    @State var forSaleToggle: Bool = true
    @State var dropDownType: DropDownType = .none
    @State var selectedPlace: String = "1st Place"
    @State var selectedRibbon: String = "Gray Ribbon"
    @Binding var currentSearchCount:Int
    var ribbonArray: [String] = ["Blue Ribbon", "Red Ribbon", "Yellow Ribbon", "White Ribbon", "Pink Ribbon","Green Ribbon","Purple Ribbon","Brown Ribbon","Gray Ribbon","Aqua Ribbon","Black Ribbon"]
    var placesArray: [String] = ["1st Place", "2nd Place", "3rd Place", "4th Place", "5th Place", "6th Place", "7th Place", "8th Place", "9th Place", "10th Place"]
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                modeAndToggle
                    .padding(.top, 10)
                    .padding(.bottom, 5)
                Divider()
                    .background(Color.white)
                
                ZStack{
                    Color.clear
                    
                    HStack(spacing: 0){
                        
                        leftView
                        
                        rightView
                    }
                    
                }
                
                    
            }
            // Commented out top view
//            if !isCheckIn {
//                dropDowns
//            }
        }.onAppear(perform: {
            isCheckIn = UserSettings.shared.selectedMode ?? false
        })
        .frame(width: 1060, height: 540)
        .glassBackgroundEffect()
        
    }
}

//#Preview {
//    HomeTabLayout()
//}
