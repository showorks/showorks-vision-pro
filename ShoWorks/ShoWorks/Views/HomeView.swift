//
//  HomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI
import UIKit

enum ListOptions: String, Hashable, CaseIterable {
    case aoption = "A option"
    case boption = "B option"
    case coption = "C option"
    case doption = "D option"
}

struct HomeView: View {
    
    @State private var mListOption: ListOptions?
     
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel

    @State var alertItem: AlertItem?
    
    @State var mScreenState: AppConstant.AppStartupStatus?

    @ObservedObject var homeViewModel = HomeViewModel()

    var body: some View {
     
        ZStack{
            ShoWorksBackground()
                .edgesIgnoringSafeArea(.all)
            
            NavigationSplitView {
                List(ListOptions.allCases, id: \.self, selection: $mListOption) { listoption in
                    NavigationLink(listoption.rawValue, value: listoption)
                }.navigationTitle("showorks".localized())
            } detail: {
                Text(mListOption?.rawValue ?? "")
                    .font(.largeTitle)
            }.navigationBarHidden(true)
            .navigationViewStyle(.automatic)
            .alert(item: self.$alertItem, content: { a in
                a.asAlert()
            }).padding(.top,90)
            
        }.edgesIgnoringSafeArea(.all)
        
    }
    
    func infoMethod(){
        
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
//            Task {
////                await homeViewModel.loadPlistArrayWithSheetsDetailData()
//                DataCenter.sharedInstance.setupWithAccessKey(_accessKey: UserSettings.shared.accessKey, andSecretKey: UserSettings.shared.secretKey) { downloadCompleted in
//                    print(downloadCompleted)
//                }
//            }
    }
}

#Preview {
    HomeView()
}
