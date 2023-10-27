//
//  ContentView.swift
//  ShoWorks
//
//  Created by Lokesh on 12/07/23.
//

import SwiftUI
import RealityKit
import RealityKitContent


struct SplashView: View {
    let navigationTransition = AnyTransition.opacity.animation(.easeOut(duration: 2))

    @State var pushToNext: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ShoWorksBackground()
                    .navigationBarHidden(true)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            self.pushToNext = true
                        }
                    }
//                    .navigationDestination(isPresented: $pushToNext) {
//                        
//                        if UserSettings.shared.isDemoUserEnabled == true {
//                            InputSerial()
//                        }else{
//                            if !Utilities.sharedInstance.checkStringContainsText(text: UserSettings.shared.serialKey) {
//                                InputSerial()
//                            }else{
//                                HomeView(mScreenState: AppConstant.AppStartupStatus.fetchSheetFromLocal)
//                            }
//                        }
//                        
//                    }.transition(navigationTransition)
                ShoWorksLogo()            

            }
            .onAppear {
                UserSettings.shared.roundRobinBackgroundImageIndex = UserSettings.shared.roundRobinBackgroundImageIndex! + 1
                if UserSettings.shared.roundRobinBackgroundImageIndex! == 2 {
                    UserSettings.shared.roundRobinBackgroundImageIndex = 0
                }
            }
        }
        .navigationViewStyle(.automatic)
        
    }
}

#Preview {
    SplashView()
}
