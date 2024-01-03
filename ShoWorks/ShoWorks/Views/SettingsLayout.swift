//
//  SettingsLayout.swift
//  ShoWorks
//
//  Created by Lokesh on 31/10/23.
//

import SwiftUI

struct SettingsLayout: View {
    
    @State var isCheckIn: Bool = true
    @State var displayListAfterScan: Bool = false
    var body: some View {
        
        ZStack{
            VStack(spacing: 15){
                Text("User Settings")
                    .font(.sfProRegular(size: 22))
                    .padding(.top,40)
                
                ZStack{
                    Capsule()
                        .fill(.white.opacity(0.3))
                        .frame(width: 820, height: 55)
                        .glassBackgroundEffect()
                    
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 5) {
                                ForEach(1...99, id: \.self) { index in
                                    Text(String(index))
                                        .frame(width: 25, height: 25, alignment: .center)
                                        .padding()
                                        .overlay(
                                            Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .padding(10)
                                        )
                                        
                                }
                            }
                            .padding(.leading,20)
                        }.frame(width: 800, height: 55)
                    .scrollIndicators(.never)
                   
                        

                     
                }
                
                if UserSettings.shared.isDemoUserEnabled! {
                    
                    SettingsViewBox(width: 820, height: 50, text: "Demo User", heading: "Logged in as:")
                        .padding(.top,20)
                }else{
                    
                    SettingsViewBox(width: 820, height: 50, text: UserSettings.shared.firstName ?? "", heading: "Logged in as:")
                        .padding(.top,20)
                }
                
                
//                if UserSettings.shared.isDemoUserEnabled! == false {
                
                if let serialKey = UserSettings.shared.serialKey {
                    if serialKey.count > 0 {
                        let last4 = String(serialKey.suffix(4))
                        SettingsViewBox(width: 820, height: 50, text: "XXXX-XXXX-XXXX-"+last4, heading: "Serial Number:")
                    }else{
                        SettingsViewBox(width: 820, height: 50, text: "XXXX-XXXX-XXXX-1234", heading: "Serial Number:")
                    }
                    
                }else{
                    SettingsViewBox(width: 820, height: 50, text: "XXXX-XXXX-XXXX-1234", heading: "Serial Number:")
                }
                
                   
//                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.2))
                        .frame(width: 820, height: 50)
                    
                    VStack(alignment: .leading, spacing: 20){
                        HStack{
//                            Circle().fill(.white).frame(width: 10)
                            Text("Default mode for scans:")
                                .fontWeight(.light)
                            Spacer().frame(width:340)
                            modeAndToggle
                        }
                        
                        

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    
                }
                .frame(width: 820, height: 50)

                ZStack{
                    RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.2))
                        .frame(width: 820, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            Toggle("Display list after search/scan:", isOn: $displayListAfterScan)
                                .onChange(of: displayListAfterScan, initial: displayListAfterScan, { oldValue, newValue in
                                    UserSettings.shared.showListAfterSearch = newValue
                                })
                                .fontWeight(.light)
                                .padding(.trailing,20)
                            
                        }
                        
                        

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    
                    
                }
                .frame(width: 820, height: 50)
                
                
                Spacer()
                    .frame(height: 20)
                
                ZStack{
                    
                    if UserSettings.shared.isDemoUserEnabled! {
                        Capsule().fill(.green)
                            .frame(width: 120, height: 35)
                        Text("Login")
                            .font(.system(size: 12))
                    }else{
                        Capsule().fill(.red)
                            .frame(width: 120, height: 35)
                        Text("Logout")
                            .font(.system(size: 12))
                    }
                }
                .onTapGesture {
                    print("button pressed")
                }
                
                Text("ShoWorks Vision Pro Beta v0.1")
                    .font(.system(size: 10))
                    .padding(.bottom, 40)

                
            }
            .frame(width: 840,alignment: .leading)
            
        }
        .onAppear(perform: {
            isCheckIn = UserSettings.shared.selectedMode ?? false
            displayListAfterScan = UserSettings.shared.showListAfterSearch ?? false
        })
        .frame(width: 940, height: 570)
    }
}

#Preview {
    SettingsLayout()
}


extension SettingsLayout{
    @ViewBuilder
    var modeAndToggle: some View{
        HStack{
            HStack(spacing: 20){
                customToggleView
            }
            
            Spacer()
        }
        .padding(.trailing, 20)
        .padding(.leading, 40)
        
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
            }
            UserSettings.shared.selectedMode = isCheckIn
        }
    }
}

struct SettingsViewBox: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var text: String
    var heading: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.2))
                .frame(width: width, height: height)
            
            VStack(alignment: .leading, spacing: 5){
                
                HStack{
//                    Circle().fill(.white).frame(width: 10)
                    Text(heading)
                        .fontWeight(.light)
                    Spacer()
                    Text("   \(text)")
                        .fontWeight(.light)
                        .padding(.trailing,20)
                }
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.leading)
            
            
        }
        .frame(width: width, height: height)
    }
}
