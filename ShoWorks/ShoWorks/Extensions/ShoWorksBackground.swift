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
            
            switch(UserSettings.shared.roundRobinBackgroundImageIndex){
            case 0:
                
                Image("background_new_8")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
            case 1:
                
                Image("background_new_9")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            case 2:
                
                Image("background_new_10")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            case 3:
                
                Image("background_new_11")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            case 4:
                
                Image("background_new_12")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

            case 5:
                Image("background_new_13")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
            case 6:
                Image("background_new_14")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            case .none:
                Image("background_new_15")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            case .some(_):
                Image("background_new_3")
                    .resizable(resizingMode: .stretch)
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            }
                     
        }.edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ShoWorksBackground()
}
