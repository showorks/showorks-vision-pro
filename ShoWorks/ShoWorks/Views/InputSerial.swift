//
//  InputSerial.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI

struct InputSerial: View {
    @State private var moveLogoBy = 0.0

    var body: some View {
        ZStack(){
            
            ShoWorksBackground()
            
            ShoWorksLogo()
                .onAppear { }
                .offset(x: CGFloat(self.moveLogoBy))
            
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
