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
            Image(UserSettings.shared.roundRobinBackgroundImageIndex==0 ? "background_new_1" : (UserSettings.shared.roundRobinBackgroundImageIndex==1 ? "background_new_2" : "background_new_3"))
                .resizable(resizingMode: .stretch)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)            
        }.edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ShoWorksBackground()
}
