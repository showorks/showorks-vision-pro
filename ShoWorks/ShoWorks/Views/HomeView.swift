//
//  HomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel
    @State var alertItem: AlertItem?
    @ObservedObject var homeViewModel = HomeViewModel()
    var body: some View {
        NavigationStack {
            ZStack {
                ShoWorksBackground()
                ShoWorksLogo()
            }
        }
        .onAppear(){
            
            if viewModel.authenticationResponse == nil {
                
                // User is in demo mode
                
//                self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "enter_serial_to_continue".localized(), dismissText: "ok".localized(), dismissAction: {
//                    // Do something here
//                }))
            }else{
                // User is authenticated by server
//                self.alertItem = AlertItem(type: .dismiss(title: "showorks".localized(), message: "user is already authenticated".localized(), dismissText: "ok".localized(), dismissAction: {
//                    // Do something here
//                    // Fetch sheets
//                }))
            }
            
            homeViewModel.loadPlistArrayWithSheetsDetailData()
            
        }
        .navigationBarHidden(true)
        .navigationViewStyle(.automatic)        
        .alert(item: self.$alertItem, content: { a in
            a.asAlert()
        })
        
    }
}

#Preview {
    HomeView()
}
