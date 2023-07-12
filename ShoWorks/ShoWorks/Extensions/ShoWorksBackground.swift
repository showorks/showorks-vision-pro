//
//  ShoWorksBackground.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI

struct ShoWorksBackground: View {
    var body: some View {
        ZStack() {
            Image("Background")
                .resizable(resizingMode: .stretch)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Image("SplashLogo")
                .frame(width: 227, height: 248, alignment: .center)
        }.edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ShoWorksBackground()
}
