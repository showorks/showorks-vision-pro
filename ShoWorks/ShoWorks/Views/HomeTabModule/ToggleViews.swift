//
//  ToggleViews.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import SwiftUI

extension HomeTabLayout{
    @ViewBuilder
    var modeAndToggle: some View{
        HStack{
            HStack(spacing: 20){
                Text("Photography Judging")
                    .font(.sfProRegular(size: 24))
//                customToggleView
            }
            
            Spacer()
        }
        .padding(.trailing, 20)
        .padding(.leading, 40)
        .padding(.top, 20)
        .padding(.bottom, 20)
        
    }
    
    
    @ViewBuilder
    var customToggleView: some View {
        ZStack{
            Capsule().fill(.black.opacity(0.4))
                .frame(width: 210, height: 40)
            
            Capsule()
                .fill(.blue)
                .frame(width: 100, height: 34)
                .padding(.leading, isCheckIn ? 0 : 100)
                .padding(.trailing, isCheckIn ? 100 : 0)
                
            
            HStack{
                Text("Check-in").font(.sfProRegular(size: 14))
                Spacer()
                Text("Judge").font(.sfProRegular(size: 14))
            }
            .padding(.leading, 20)
            .padding(.trailing, 30)
            
        }
        .frame(width: 210, height: 49)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isCheckIn.toggle()
                UserSettings.shared.selectedMode = isCheckIn
            }
            
        }
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isOn ? Color.green : Color.red)
            .frame(width: 40, height: 20) // Set your desired size here
            .overlay(
                Circle()
                    .fill(Color.white)
                    .frame(width: 15, height: 15) // Adjust the circle size
                    .offset(x: isOn ? 8 : -8)
            )
            .onTapGesture {
                self.isOn.toggle()
            }
            
    }
}
