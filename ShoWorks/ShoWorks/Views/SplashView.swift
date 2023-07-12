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
                    .navigationDestination(isPresented: $pushToNext) {
                        InputSerial()
                    }.transition(navigationTransition)
                ShoWorksLogo()
            }
        }
        .navigationViewStyle(.automatic)
        
    }
}

#Preview {
    SplashView()
}
