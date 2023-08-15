//
//  KioskWelcomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import SwiftUI

struct KioskWelcomeView: View {

    @EnvironmentObject var viewModel: KioskViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackground()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Text(SheetUtility.sharedInstance.getFairNameOfCurrentSheet(sheetDic: viewModel.selectedDictionary)).font(.heleveticNeueMedium(size: 50))
                        .foregroundColor(.white)
                        .padding(.leading,50)
                    Spacer().frame(height: 60)
                    ShoWorksLogo()
                    
                    Button(action: {
                          
                        print("Tap here to check-in")
                       }, label: {
                           VStack{
                               Text("tap_here_to".localized())
                                   .font(.system(size: 42))
                                   .font(.heleveticNeueMedium(size: 50))
                               Text("check_in_txt".localized())
                                   .font(.system(size: 70))
                                   .font(.heleveticNeueBold(size: 50))
                           }
                           .padding(.trailing,250)
                           .padding(.leading,250)
                           .padding(.top,30)
                           .padding(.bottom,30)
                           .cornerRadius(5)
                    })
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .background(Color.aBlueBackgroundColor)
                    .padding(.init(top: 30, leading: 50, bottom: 30, trailing: 50))
                    .cornerRadius(5)
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    KioskWelcomeView()
}
