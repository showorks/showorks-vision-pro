//
//  PreviousNextButtons.swift
//  iPadSingleScreen
//
//  Created by Anubhav Rawat on 17/10/23.
//

import Foundation
import SwiftUI

extension KioskWelcomeNewView{
        @ViewBuilder
        var previousNext: some View{
            HStack(spacing: 15){
                Spacer()
                
                Button {
                    print("previous")
                } label: {
                    ZStack{
                        Rectangle().fill(.cyan).frame(width: 100, height: 45)
                            .cornerRadius(10)
                        Text("Previous")
                    }
                }
                
                Button {
                    print("next")
                } label: {
                    ZStack{
                        Rectangle().fill(.white).frame(width: 85, height: 45)
                            .cornerRadius(10)
                        Text("Next")
                    }
                }
            }
            .frame(width: deviceWidth * 0.56)
            .font(.system(size: 16))
            .foregroundColor(.black)
        }
    }
