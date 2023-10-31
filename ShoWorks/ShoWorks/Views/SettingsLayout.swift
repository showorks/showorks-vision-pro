//
//  SettingsLayout.swift
//  ShoWorks
//
//  Created by Lokesh on 31/10/23.
//

import SwiftUI

struct SettingsLayout: View {
    
    @State var isCheckIn: Bool = true
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 15){
                Text("User Settings")
                    .font(.largeTitle)
                    .padding(.top,20)
                
                if UserSettings.shared.isDemoUserEnabled! {
                    
                    SettingsViewBox(width: 820, height: 70, text: "Demo User", heading: "Logged in as:")
                        .padding(.top,20)
                }else{
                    
                    SettingsViewBox(width: 820, height: 70, text: UserSettings.shared.firstName ?? "", heading: "Logged in as:")
                        .padding(.top,20)
                }
                
                
//                if UserSettings.shared.isDemoUserEnabled! == false {
                    SettingsViewBox(width: 820, height: 70, text: "XXXX-XXXX-XXXX-1234", heading: "Serial Number")
//                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.2))
                        .frame(width: 820, height: 70)
                    
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                            Circle().fill(.white).frame(width: 10)
                            Text("Default mode for scans:")
                                .fontWeight(.light)
                            Spacer().frame(width:340)
                            modeAndToggle
                        }
                        
                        

                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .padding(.leading)
                    
                    
                }
                .frame(width: 820, height: 70)
                
                
                Spacer()
                    .frame(height: 50)
                
                Text("ShoWorks Vision Pro v1.0")
                    .font(.subheadline)
                
                ZStack{
                    
                    if UserSettings.shared.isDemoUserEnabled! {
                        Capsule().fill(.green)
                            .frame(width: 160, height: 45)
                        Text("Login")
                            .font(.system(size: 15))
                    }else{
                        Capsule().fill(.red)
                            .frame(width: 160, height: 45)
                        Text("Logout")
                            .font(.system(size: 15))
                    }
                }
                .padding(.bottom, 40)
                .onTapGesture {
                    print("button pressed")
                }
            }
            .frame(width: 840,alignment: .leading)
            
        }
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
                Text("Check in")
                Spacer()
                Text("Judge")
            }
            .padding(.leading, 20)
            .padding(.trailing, 30)
            
        }
        .frame(width: 210, height: 49)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                isCheckIn.toggle()
            }
            
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
                    Circle().fill(.white).frame(width: 10)
                    Text(heading)
                        .fontWeight(.light)
                    Spacer()
                    Text("   \(text)")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .padding(.trailing,20)
                }
                
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.leading)
            
            
        }
        .frame(width: width, height: height)
    }
}
