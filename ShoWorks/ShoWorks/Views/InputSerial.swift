//
//  InputSerial.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI

struct InputSerial: View {
    
    @State private var moveLogoBy = 0.0
    @State private var isCompleteLayoutHidden = true
    @State private var isSerialNumberTextFieldHidden = true
    @State private var aSerialNumberButtonTitle = "enter_a_num".localized()
    @State private var aContinueButtonTitle = "continue_in_demo_mode".localized()
    @State var aSerialNumberString: String = ""
    @State var alertItem: AlertItem?
    
    var body: some View {
        ZStack(){
            
            ShoWorksBackground()
            
            ShoWorksLogo()
                .onAppear { }
                .offset(x: CGFloat(self.moveLogoBy))
            
            VStack(alignment: .center, content: {
               TopLayout()
                Text("enter_serial_text".localized()).font(.heleveticNeueThin(size: 18))
                    .foregroundColor(.white)
                VStack(){
                    HStack(){
                       
                        Text(self.aSerialNumberButtonTitle)
                            .font(.system(size: 15))
                            .padding(10)
                            .padding(.leading,20)
                            .padding(.trailing,20)
                            .background(Color.aLightGrayColor)
                            .foregroundColor(Color.aTextGrayColor)
                            .cornerRadius(5)
                            .onTapGesture {
                                self.isSerialNumberTextFieldHidden = !self.isSerialNumberTextFieldHidden
                                self.aSerialNumberButtonTitle = self.isSerialNumberTextFieldHidden ? "enter_a_num".localized() :
                                "cancel_btn".localized()
                                self.aContinueButtonTitle = self.isSerialNumberTextFieldHidden ? "continue_in_demo_mode".localized() :
                                "continue".localized()
                            }
                        
                        Text(self.aContinueButtonTitle)
                            .font(.system(size: 15))
                            .padding(10)
                            .padding(.leading,20)
                            .padding(.trailing,20)
                            .background(Color.aBlueTextColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .onTapGesture {
                                if (aSerialNumberString.isEmpty && !self.isSerialNumberTextFieldHidden){
                                    self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "enter_serial_to_continue".localized(), dismissText: "ok".localized(), dismissAction: {
                                        // Do something here
                                    }))
                                }else{
                                    // Proceed for validation either in Demo or in full mode
                                }
                            }

                    }.padding(.top,10)
                    
                    InputLayout(userInputtedSerialKey: $aSerialNumberString)
                        .onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isCompleteLayoutHidden = false
                            }
                            
                    }
                    .isHidden(self.isSerialNumberTextFieldHidden)
                    .frame(alignment: .center)
                    .padding(.top,10)
                    .padding(.leading,300)
                    .padding(.trailing,300)
                    
                }

                
            })
            .padding(.leading,200)
            .isHidden(self.isCompleteLayoutHidden)

            
        }.navigationBarHidden(true)
            .onAppear(){
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   withAnimation(.easeInOut(duration: 2.0)) { self.moveLogoBy = -350.0
                   }
                }
                
        }
        .alert(item: self.$alertItem, content: { a in
            a.asAlert()
        })
    }
}

#Preview {
    InputSerial()
}


struct InputLayout: View {
    @Binding var userInputtedSerialKey: String
    var body: some View {
            
            TextField("", text: $userInputtedSerialKey)
                .placeholder(when: self.userInputtedSerialKey.isEmpty) {
                    Text("serial_num_or_cancel_demo".localized()).foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.leading,50)
            }
                .font(.system(size: 14))
                .padding(10)
                .padding(.leading,20)
                .padding(.trailing,20)
                .multilineTextAlignment(.center)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(2)
        
    }
}


struct TopLayout: View {
    @State private var userInputtedSerialKey: String = ""
    var body: some View {
            
        HStack(){
            Text("welcome".localized()) .font(.heleveticNeueThin(size: 42))
                .foregroundColor(.white)
            Image("showorksLogo")
            Text("for_vision_pro".localized()).font(.heleveticNeueThin(size: 42))
                .foregroundColor(.white)
        }
        
    }
}
