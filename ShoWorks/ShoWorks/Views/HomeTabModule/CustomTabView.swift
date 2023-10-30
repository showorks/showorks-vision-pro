//
//  CustomTabView.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 29/10/23.
//

import SwiftUI

extension HomeContentView{
    @ViewBuilder
    var customTab: some View{
        ZStack{
            Capsule().fill(.clear)
                .frame(width: 50, height: 150)
                .glassBackgroundEffect()
            VStack(spacing: 6){
                
                ZStack{
                    Circle().fill(selectedTab == .tab1 ? .blue : .clear)
                        .frame(width: 38)
                    Image("TabImage1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        
                }
                .onTapGesture {
                    selectedTab = .tab1
                }
                
                ZStack{
                    Circle().fill(selectedTab == .tab2 ? .blue : .clear)
                        .frame(width: 38)
                    Image("TabImage2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                    Image(isDeviceConnected ? "green_dot" : "red_dot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 8)
                        .offset(x:8, y: 8)
                        
                }
                .onTapGesture {
                    selectedTab = .tab2
                }
                
                ZStack{
                    Circle().fill(selectedTab == .tab3 ? .blue : .clear)
                        .frame(width: 38)
                    Image("TabImage3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        
                }
                .onTapGesture {
                    selectedTab = .tab3
                }
            }
            .font(.system(size: 18))
        }
    }
}
