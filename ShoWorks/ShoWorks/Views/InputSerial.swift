//
//  InputSerial.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI

struct InputSerial: View {
    
    @State private var moveLogoBy = 0.0
    @State private var isHidden = true

    var body: some View {
        ZStack(){
            
            ShoWorksBackground()
            
            ShoWorksLogo()
                .onAppear { }
                .offset(x: CGFloat(self.moveLogoBy))
            
            VStack(alignment: .center, content: {
                HStack(){
                    Text("Welcome to") .font(.heleveticNeueThin(size: 42))
                        .foregroundColor(.white)
                    Image("showorksLogo")
                    Text("for Vision Pro").font(.heleveticNeueThin(size: 42))
                        .foregroundColor(.white)
                }.padding(.leading,200)
                .isHidden(self.isHidden)
                
                Text("Enter your ShoWorks serial number for full use or continue in DEMO MODE.").font(.heleveticNeueThin(size: 18))
                    .foregroundColor(.white)
                    .padding(.leading,200)
                    .isHidden(self.isHidden)
                
                InputLayout().isHidden(self.isHidden)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            
                            self.isHidden = false
                        }
                        
                    }
                
            })
            
        }.navigationBarHidden(true)
            .onAppear(){
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   withAnimation(.easeInOut(duration: 2.0)) { self.moveLogoBy = -350.0
                   }
                }
                
            }
    }
}

#Preview {
    InputSerial()
}


struct InputLayout: View {
    @State private var userInputtedSerialKey: String = ""
    var body: some View {
        ZStack{
            TextField("Serial Number or Cancel for DEMO MODE", text: $userInputtedSerialKey)
                .frame(alignment: .center)
        }
        
    }
}
