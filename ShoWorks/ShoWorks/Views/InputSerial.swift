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
    @State private var isContinueDisabled = true
    @State private var moveToNextScreen = false
    @State private var isSerialNumberTextFieldHidden = true
    @State private var aSerialNumberButtonTitle = "enter_a_num".localized()
    @State private var aContinueButtonTitle = "continue".localized()
    @State private var aSerialNumberString: String = "" // testing 395605390285163174
    @State private var alertItem: AlertItem?
    @ObservedObject var authenticationViewModel: ShoWorksAuthenticationModel = ShoWorksAuthenticationModel()
    @State var mScreenState: AppConstant.AppStartupStatus = AppConstant.AppStartupStatus.demoMode
    
    var body: some View {
        ZStack(){
            
            ShoWorksBackground()
            
            VStack(alignment: .center, content: {
                Text("welcome_old".localized())
                    .font(.sfProRegular(size: 26))
                
                
                Image("showorks_logo_new")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .frame(alignment: .center)
                
                Text("enter_serial_text".localized()).font(.sfProRegular(size: 10))
                    .foregroundColor(.white).padding(.top,10)
                
                
                InputLayout(userInputtedSerialKey: $aSerialNumberString,isLoaderSpinning: $authenticationViewModel.isLoading,isContinueDisabled: $isContinueDisabled)

                Text(self.aContinueButtonTitle)
                    .font(.sfProRegular(size: 15))
                    .padding(10)
                    .frame(width: 300)
                    .background(Image("continue_btn")).opacity(self.isContinueDisabled ? 0.5 : 1.0)
                    .disabled(self.isContinueDisabled)
                    .foregroundColor(Color.white)
                    .cornerRadius(15)
                    .onTapGesture {
                        if(self.authenticationViewModel.isLoading){
                            return
                        }
                        continueButtonTapped()
                    }
                    
                
                Text("or_text".localized()).font(.sfProLight(size: 10))
                    .foregroundColor(.white).padding(.top,5).padding(.bottom,5)
                
                Text("explore_demo".localized())
                    .font(.sfProRegular(size: 15))
                    .padding(10)
                    .frame(width: 300)
                    .cornerRadius(15)
                    .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white, lineWidth: 1)
                        )
                    .foregroundColor(Color.white)
                    .onTapGesture {
                        continueButtonTapped()
                    }
                
                

                ActivityIndicatorView(isVisible: $authenticationViewModel.isLoading, type: .flickeringDots(count: 10))
                         .frame(width: 50.0, height: 50.0)
                         .foregroundColor(.white)
                
            })
            .navigationDestination(
                 isPresented: $authenticationViewModel.isUserAuthenticated) {
                     HomeView(mScreenState: mScreenState).environmentObject(authenticationViewModel)
                      Text("")
                          .hidden()
                 }
            .padding(50)
            .background( VisualEffectBlur(blurStyle: .extraLight)
                .ignoresSafeArea())
            .cornerRadius(20)
                        
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
                    if !Utilities.sharedInstance.isNetworkStatusAvailable() {
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
    @Binding var isContinueDisabled: Bool
    var body: some View {
            
            TextField("", text: $userInputtedSerialKey)
                .placeholder(when: self.userInputtedSerialKey.isEmpty) {
                    Text("enter_a_num".localized()).foregroundColor(.white)
                                           .multilineTextAlignment(.center)
                                           .font(.sfProLight(size: 14))
                                           .frame(width: 300)
                }
                .onChange(of: userInputtedSerialKey, {
                    isContinueDisabled = validateSerialNumber(serialKey: userInputtedSerialKey)
                })
                .disabled(isLoaderSpinning)
                .keyboardType(.numberPad)
                .font(.sfProLight(size: 14))
                .padding()
                .frame(width: 300)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.white)
                .cornerRadius(2)
        
    }
    
    func validateSerialNumber(serialKey:String) -> Bool{

        if Utilities.sharedInstance.checkStringContainsText(text: serialKey){
            
            if(serialKey.count >= AppConstant.SerialNumberMinLength && serialKey.count <= AppConstant.SerialNumberMaxLength) {
                return false
            }else{
                return true
            }
        }else{
            return true
        }
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
