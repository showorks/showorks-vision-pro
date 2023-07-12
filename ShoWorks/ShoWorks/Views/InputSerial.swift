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
            InputLayout().isHidden(self.isHidden)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.isHidden = false
                    }
                    
                }
            
            
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
