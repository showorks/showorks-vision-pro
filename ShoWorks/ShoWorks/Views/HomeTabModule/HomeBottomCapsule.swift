//
//  HomeBottomCapsule.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import SwiftUI

struct HomeBottomCapsule: View {
    @Binding var isCheckIn:Bool
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(.clear)
                .glassBackgroundEffect()
                .frame(width: isCheckIn ? 350 : 150, height: 60)
            Capsule()
                .stroke(.white.opacity(0.6), lineWidth: 0.5)
                .frame(width: isCheckIn ? 350 : 150, height: 60)
            
            
            HStack{
//                ZStack{
//                    Capsule().fill(.white.opacity(0.2))
//                        .frame(width: 160, height: 45)
//                    
//                    Text("Return to Summary")
//                        .font(.system(size: 15))
//                }
//                .onTapGesture {
//                    print("summary pressed")
//                }
                
//                ZStack{
//                    Capsule().fill(.black.opacity(0.4))
//                        .frame(width: 160, height: 45)
//                    
//                    Text("Previous")
//                        .font(.system(size: 15))
//                }
//                .onTapGesture {
//                    print("previous pressed")
//                }
                
                if isCheckIn == false {
                    
                    ZStack{
                        Capsule().fill(.green)
                            .frame(width: 130, height: 40)
                        
                        Text("Save")
                            .font(.heleveticNeueMedium(size: 14))
                    }
                    .onTapGesture {
                        print("confirm pressed")
                    }
                }else{
                    
                    ZStack{
                        Capsule().fill(.black.opacity(0.4))
                            .frame(width: 160, height: 45)
                        
                        Text("Skip")
                            .font(.system(size: 15))
                    }
                    .onTapGesture {
                        print("skip pressed")
                    }
                    ZStack{
                        Capsule().fill(.green)
                            .frame(width: 160, height: 45)
                        
                        Text("Check-in")
                            .font(.system(size: 15))
                    }
                    .onTapGesture {
                        print("confirm pressed")
                    }
                }
                
                
            }
        }
    }
}

struct BottomCapsuleButton: View {
    
    var text: String
    
    var body: some View {
        ZStack{
            Capsule().fill(.white.opacity(0.6))
                .frame(width: 165, height: 45)
            
            Text(text)
                .font(.system(size: 15))
                
        }
    }
}
//
//#Preview {
//    HomeBottomCapsule()
//}
