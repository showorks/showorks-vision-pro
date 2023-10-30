//
//  HomeBottomCapsule.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import SwiftUI

struct HomeBottomCapsule: View {
    var body: some View {
        ZStack{
            Capsule()
                .fill(.clear)
                .glassBackgroundEffect()
                .frame(width: 680, height: 60)
            Capsule()
                .stroke(.white.opacity(0.6), lineWidth: 0.5)
                .frame(width: 680, height: 60)
            
            
            HStack{
                ZStack{
                    Capsule().fill(.white.opacity(0.2))
                        .frame(width: 160, height: 45)
                    
                    Text("Return to Summary")
                        .font(.system(size: 15))
                }
                .onTapGesture {
                    print("summary pressed")
                }
                ZStack{
                    Capsule().fill(.black.opacity(0.4))
                        .frame(width: 160, height: 45)
                    
                    Text("Previous")
                        .font(.system(size: 15))
                }
                .onTapGesture {
                    print("previous pressed")
                }
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
                    
                    Text("Confirm Entry")
                        .font(.system(size: 15))
                }
                .onTapGesture {
                    print("confirm pressed")
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

#Preview {
    HomeBottomCapsule()
}
