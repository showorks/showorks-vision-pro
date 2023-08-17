//
//  KioskWelcomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import SwiftUI

struct KioskWelcomeView: View {

    @EnvironmentObject var viewModel: KioskViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackground()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    HStack(){
                        Spacer()
                        
                        Button(action: {
                              
                            presentationMode.wrappedValue.dismiss()
                            
                           }, label: {
                               Image(systemName: "multiply.circle")
                                   .resizable(resizingMode: .stretch)
                                   .foregroundColor(.white)
                        })
                        .foregroundColor(Color.white)
                        .frame(width: 50.0, height: 50.0)
                        .padding(.trailing, 50)
                        .padding(.top, 50)
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    Text(SheetUtility.sharedInstance.getFairNameOfCurrentSheet(sheetDic: viewModel.selectedDictionary)).font(.heleveticNeueMedium(size: 50))
                        .foregroundColor(.white)
                        .padding(.leading,50)
                    Spacer().frame(height: 40)
                    Image("SplashLogo")
                        .resizable()
                        .frame(width: 150, height: 170, alignment: .center)
                    
                    Button(action: {
                          
                        print("Tap here to check-in")
                       }, label: {
                           VStack{
                               Text("tap_here_to".localized())
                                   .font(.system(size: 36))
                                   .font(.heleveticNeueMedium(size: 36))
                                   .foregroundColor(Color.white)
                               Text("check_in_txt".localized())
                                   .font(.system(size: 55))
                                   .font(.heleveticNeueBold(size: 55))
                                   .foregroundColor(Color.white)
                           }
                           .padding(.trailing,250)
                           .padding(.leading,250)
                           .padding(.top,20)
                           .padding(.bottom,20)
                           .cornerRadius(5)
                    })
                    .cornerRadius(5)
                    .foregroundColor(Color.white)
                    .background(Color.aBlueBackgroundColor)
                    .padding(.init(top: 20, leading: 40, bottom: 20, trailing: 40))
                    .cornerRadius(5)
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack{
                        Spacer()
                        VStack(){
                            Text("powered_by".localized()).font(.heleveticNeueMedium(size: 22))
                                .foregroundColor(.white)
                                .padding(.trailing,50)
                                .multilineTextAlignment(.center)
                            Image("showorksLogo")
                                .padding(.trailing,50)
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    KioskWelcomeView()
}
