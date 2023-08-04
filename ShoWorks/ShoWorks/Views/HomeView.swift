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
    
    @State var aUserName: String = ""
    
    @State var mScreenState: AppConstant.AppStartupStatus?

    @ObservedObject var homeViewModel = HomeViewModel()

    var body: some View {
     
        ZStack{
            ShoWorksBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HomeTitleLayout(aUserName: $aUserName)
                NavigationSplitView {
                    List(ListOptions.allCases, id: \.self, selection: $mListOption) { listoption in
                        NavigationLink(listoption.rawValue, value: listoption)
                    }.navigationBarHidden(true)
                } detail: {
//                    Text(mListOption?.rawValue ?? "")
//                        .font(.largeTitle)
                    MasterLayout()
                        .navigationBarHidden(true)
                }.navigationBarHidden(true)
//                .background(Color.white)
                .navigationSplitViewStyle(.automatic)
                .alert(item: self.$alertItem, content: { a in
                    a.asAlert()
                })
                
            }
                .padding(.top,150)
        }
        .onAppear {
            if viewModel.authenticationResponse == nil {
                aUserName = "demo_mode".localized()
            }else{
                aUserName = UserSettings.shared.firstName ?? "demo_mode".localized()
            }
        }
        
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



struct HomeTitleLayout: View {
    @Binding var aUserName: String
    var body: some View {
            
        HStack(){
            Text("welcome_new".localized()).font(.title)
                .foregroundColor(.white)
                .padding(.leading,50)
            Text(aUserName).font(.title)
                .foregroundColor(.white)
            Spacer()
            Image("showorksLogo")
                .padding(.trailing,50)
            
        }
        
    }
}


extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

struct MasterLayout: View {

    var body: some View {
            
        VStack {

                MasterTopLayout()
                MasterCenterLayout()
                HStack(){
                    
                    Text("Go to Sheet")
                        .font(.system(size: 20))
                        .padding(.init(top: 40, leading: 70, bottom: 40, trailing: 70))
                        .background(Color.aBlueBackgroundColor)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                    
                }.padding(50)
                Spacer()
               }
                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                   .background(Color.aDarkGreyBackgroundColor)
                   .edgesIgnoringSafeArea(.all)
    }
}

struct MasterTopLayout: View {
    
    var body: some View {
        VStack(){
            Text("Home and Hobby Judging").foregroundColor(.black)
            .padding(.top,10)
        
            Rectangle()
            .stroke(Color.black, lineWidth: 1).frame(maxHeight: 1)

            HStack(){
                Text("SHEET PROPERTIES").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
                Spacer()
            }
            .padding(.top,30)
            .padding(.leading,30)
            HStack(){
                Text("Created on Mon 1 Jul at 2:33 PM").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
                Spacer()
                Text("Updated on Mon 30 Sept at 3.52 PM").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
            }
            .padding(.leading,30)
            .padding(.trailing,30)
        }
        
    }
}

struct MasterCenterLayout: View {
    
    var body: some View {
        VStack(){
            MasterCenterDepartmentLayout()
            Rectangle()
            .stroke(Color.black, lineWidth: 1).frame(maxHeight: 1)

            MasterCenterDivisionsLayout()
            Rectangle()
            .stroke(Color.black, lineWidth: 1).frame(maxHeight: 1)

            MasterCenterClassesLayout()
            Rectangle()
            .stroke(Color.black, lineWidth: 1).frame(maxHeight: 1)

            MasterCenterEntriesLayout()

        }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(20)
            .background(.white)
            .cornerRadius(5) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 1)
            )
            .padding(.leading,30)
            .padding(.trailing,30)
    }
}

struct MasterCenterDepartmentLayout: View {
    
    var body: some View {
     
        HStack(){
            Text("Number of Departments in this sheet").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
            Spacer()
            Text("1").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct MasterCenterDivisionsLayout: View {
    
    var body: some View {
     
        HStack(){
            Text("Number of Divisions in this sheet").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
            Spacer()
            Text("15").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct MasterCenterClassesLayout: View {
    
    var body: some View {
     
        HStack(){
            Text("Number of Classes in this sheet").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
            Spacer()
            Text("258").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        }
    }
}

struct MasterCenterEntriesLayout: View {
    
    var body: some View {
     
        HStack(){
            Text("Number of Entries in this sheet").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
            Spacer()
            Text("3,496").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        }
    }
}
