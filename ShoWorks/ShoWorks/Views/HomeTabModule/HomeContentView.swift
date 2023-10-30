//
//  HomeContentView.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 27/10/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

class Entry: Identifiable{
    var id: UUID
    var exhibitor: String
    var department: String
    var club: String
    var entryNumber: String
    var wen: String
    var division: String
    var Class: String
    var description: String
    var validationNumber: String
    var entryValidationDate: String
    var stateFair: String
    var salePrice: String
    
    init(exhibitor: String, department: String, club: String, entryNumber: String, wen: String, division: String, Class: String, description: String, validationNumber: String, entryValidationDate: String, stateFair: String, salePrice: String) {
        self.id = UUID()
        self.exhibitor = exhibitor
        self.department = department
        self.club = club
        self.entryNumber = entryNumber
        self.wen = wen
        self.division = division
        self.Class = Class
        self.description = description
        self.validationNumber = validationNumber
        self.entryValidationDate = entryValidationDate
        self.stateFair = stateFair
        self.salePrice = salePrice
    }
}

enum Tabs: String{
    case tab1, tab2, tab3
}


//1024
struct HomeContentView: View {
    
    @State var selectedTab: Tabs = .tab1
    @State private var offsetY: CGFloat = 0
    @State private var isDragging = false
    
    var body: some View {
        
        ZStack{
            ShoWorksBackground()
//                .resizable()
//                .frame(width: 1366, height: 824)
            
            
            HStack(spacing: 20){
                
                customTab
                
                if selectedTab == .tab1{
                    ZStack{
                        VStack(spacing: 20){
                            SearchBarCapsule()
                            HomeTabLayout()
                                .glassBackgroundEffect()
                                .padding(.bottom, 40)
                                
                        }
                        VStack{
                            Spacer()
                            
                            HomeBottomCapsule()
                                .padding(.bottom, 90)
                        }
                        
                            
                    }
                }else if selectedTab == .tab2{
                    ZStack{
                        Color.white.opacity(0.3)
                            .frame(width: 960, height: 540)
                            .glassBackgroundEffect()
                        
                        QRScanTabView()
                    }
                }else{
                    ZStack{
                        Color.white.opacity(0.3)
                            .frame(width: 960, height: 540)
                            .glassBackgroundEffect()
                        
                        Text("Place tab 3 here")
                    }
                }
                
                
            }
        }.navigationBarHidden(true)
    }
}

#Preview(windowStyle: .automatic) {
    HomeContentView()
        
}


struct QRScanTabView: View {
    
    var body: some View {
        ZStack(){
            
            VStack(alignment: .center, content: {
                
                Image("connected_state")
              
                Text("Device is connected and ready to scan")
                    .foregroundColor(.white)
               
                
            })
                        
        }
    }
}
