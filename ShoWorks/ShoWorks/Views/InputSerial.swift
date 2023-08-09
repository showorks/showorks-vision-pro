//
//  InputSerial.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI
import ActivityIndicatorView

struct InputSerial: View {
    
    @State private var moveLogoBy = 0.0
    @State private var isCompleteLayoutHidden = true
    @State private var moveToNextScreen = false
    @State private var isSerialNumberTextFieldHidden = true
    @State private var aSerialNumberButtonTitle = "enter_a_num".localized()
    @State private var aContinueButtonTitle = "continue_in_demo_mode".localized()
    @State private var aSerialNumberString: String = "" // testing 395605390285163174
    @State private var alertItem: AlertItem?
    @ObservedObject var authenticationViewModel: ShoWorksAuthenticationModel = ShoWorksAuthenticationModel()
    @State var mScreenState: AppConstant.AppStartupStatus = AppConstant.AppStartupStatus.demoMode
    
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
                                if(self.authenticationViewModel.isLoading){
                                    return
                                }
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
                            .background(Color.aBlueBackgroundColor)
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                            .onTapGesture {
                                continueButtonTapped()
                            }
                        
                        ActivityIndicatorView(isVisible: $authenticationViewModel.isLoading, type: .flickeringDots(count: 10))
                                 .frame(width: 50.0, height: 50.0)
                                 .foregroundColor(.white)

                    }.padding(.top,10)
                    
                    InputLayout(userInputtedSerialKey: $aSerialNumberString,isLoaderSpinning: $authenticationViewModel.isLoading)
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
                    
                    
                    .navigationDestination(
                         isPresented: $authenticationViewModel.isUserAuthenticated) {
                             HomeView(mScreenState: mScreenState).environmentObject(authenticationViewModel)
                              Text("")
                                  .hidden()
                         }
                }

                
            })
            .padding(.leading,200)
            .isHidden(self.isCompleteLayoutHidden)
                        
        }
        .navigationBarHidden(true)
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
    
    func continueButtonTapped(){
        
        if(self.authenticationViewModel.isLoading){
            return
        }

        if self.aSerialNumberString.isEmpty && !self.isSerialNumberTextFieldHidden{
            self.showAlertForEnteringSerialNumberToContinue()
        }
        else if self.isSerialNumberTextFieldHidden && self.aSerialNumberString.isEmpty {
            // This means user is trying to go for a demo mode
            // Lets load up everything in the demo mode
            UserSettings.shared.isDemoUserEnabled = true
            authenticationViewModel.isUserAuthenticated = true // But authentication is in demo mode
            mScreenState = AppConstant.AppStartupStatus.demoMode
        }
        else if self.aSerialNumberString.count>0 {
            // Validate the serial number through an API first
            self.validateSerialNumber(serialKey: self.aSerialNumberString)
            mScreenState = AppConstant.AppStartupStatus.fetchSheetFromServer
        }

    }
    
    func validateSerialNumber(serialKey:String){

        if Utilities.sharedInstance.checkStringContainsText(text: serialKey){
            
            if(serialKey.count >= AppConstant.SerialNumberMinLength && serialKey.count <= AppConstant.SerialNumberMaxLength) {
                
                UserSettings.shared.serialKey = serialKey
                
                if self.isDataPresentForCurrentSerialNumber(){
                    // PUSH TO HOME SCREEN WITH STATUS fetchSheetFromLocal
                    mScreenState = AppConstant.AppStartupStatus.fetchSheetFromLocal
                }else{
                    if Utilities.sharedInstance.isNetworkStatusAvailable() {
                        self.showNoNetworkAlertMessage()
                    }else{
                        UserSettings.shared.isDemoUserEnabled = false
                        mScreenState = AppConstant.AppStartupStatus.fetchSheetFromServer
                        authenticationViewModel.authenticateWithSerialNumber(serialNumber: aSerialNumberString)
                    }
                }
            }else{
                self.showInvalidAlertMessage()
            }
        }else{
            self.showAlertForEnteringSerialNumberToContinue()
        }
    }
    
    func showInvalidAlertMessage(){
        self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "InvalidSerialKeyAlertMessage".localized(), dismissText: "ok".localized(), dismissAction: {
            // Do something here
        }))
    }
    
    func showNoNetworkAlertMessage(){
        self.alertItem = AlertItem(type: .dismiss(title: "ServerNotRespondingTitle".localized(), message: "ServerNotResponding".localized(), dismissText: "ok".localized(), dismissAction: {
            // Do something here
        }))
    }
    
    func showAlertForEnteringSerialNumberToContinue(){
        self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "enter_serial_to_continue".localized(), dismissText: "ok".localized(), dismissAction: {
            // Do something here
        }))
    }
    
    func isDataPresentForCurrentSerialNumber() -> Bool {
        var dataPath:String! = PlistManager.sharedInstance.getPlistFilePathForCurrentSettings()

        dataPath = dataPath.stringByDeletingLastPathComponent

        return FileManager.default.fileExists(atPath: dataPath)
    }
}

#Preview {
    InputSerial()
}


struct InputLayout: View {
    @Binding var userInputtedSerialKey: String
    @Binding var isLoaderSpinning: Bool
    var body: some View {
            
            TextField("", text: $userInputtedSerialKey)
                .placeholder(when: self.userInputtedSerialKey.isEmpty) {
                    Text("serial_num_or_cancel_demo".localized()).foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.leading,50)
                }.disabled(isLoaderSpinning)
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
