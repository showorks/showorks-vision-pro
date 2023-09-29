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
            Image("black_bg_1")
                .resizable(resizingMode: .stretch)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)            
        }.edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ShoWorksBackground()
}
