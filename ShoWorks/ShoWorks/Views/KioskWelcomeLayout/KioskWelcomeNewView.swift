//
//  ContentView.swift
//  iPadSingleScreen
//
//  Created by Anubhav Rawat on 17/10/23.
//

import SwiftUI



struct KioskWelcomeNewView: View {
    
//    1366 × 1024
//    #if !os(xrOS)
//    var deviceHeight = UIScreen.main.bounds.height
//    var deviceWidth = UIScreen.main.bounds.width
//
//    var capsuleWidth = UIScreen.main.bounds.width * 0.56
//    #endif
//
//    #if os(xrOS)
    
    var deviceHeight: CGFloat = 924
    var deviceWidth: CGFloat = 1366
    
    var capsuleWidth: CGFloat = 1366 * 0.56
    
//    #endif
    
    var colors: [Color] = [.white, .orange, .red, .green, .indigo, .yellow, .cyan, .purple, .white, .orange, .red, .green, .indigo, .yellow, .cyan, .purple]
    
    
    var body: some View {
        ZStack {
            
            headerAndFooter
            
            VStack(spacing: 10){
                
                centerCard
                
                previousNext
                 
                CapsuleLayout(isNumberStack: false) {
                    HStack{
                        ForEach(0..<colors.count){ind in
                            ZStack{
                                Circle().fill(colors[ind]).frame(width: 50)

                                Image(systemName: "bolt.heart.fill")
                                    .font(.system(size: 19))
                            }
                        }
                    }
                }

            }
            
        }
        .padding(.horizontal, deviceWidth * 0.22)
        .background{
            Image("BackgroundImage")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .blur(radius: 6)
                .frame(width: deviceWidth, height: deviceHeight)
        }
    }
}

struct KioskWelcomeNewView_Previews: PreviewProvider {
    static var previews: some View {
        KioskWelcomeNewView()
    }
}
