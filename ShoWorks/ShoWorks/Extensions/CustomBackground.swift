//
//  CustomBackground.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import SwiftUI

struct CustomBackground: View {
    var mSelectedBackground: String = "Background_1"
    var body: some View {
        ZStack() {
            Image(mSelectedBackground)
                .resizable(resizingMode: .stretch)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }.edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CustomBackground()
}
