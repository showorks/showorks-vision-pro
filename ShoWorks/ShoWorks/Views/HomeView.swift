//
//  HomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI
import UIKit


struct HomeViewData: Identifiable {
    let id = UUID()
    var fileName: String
    var createdTime: String
}

struct HomeView: View {
         
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
                    
                    SlaveLayout()
                    
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
            Text("welcome_new".localized() + " " + aUserName).font(.title)
                .foregroundColor(.white)
                .padding(.leading,50)
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

struct SlaveLayout : View {
    
    private let slaveValues: [HomeViewData] = [
        HomeViewData(fileName:"Home and Hobby Judging",createdTime: "Created on Mon 1 Jul at 2:33PM"),
        HomeViewData(fileName:"Kiosk Check-in",createdTime: "Created on Mon 1 Jul at 2:33PM")
       ]
    
    @State private var mListOption: HomeViewData?

    var body: some View
    {
        VStack {
            SlaveTopLayout()
            
            Rectangle()
                .stroke(Color.black, lineWidth: 1).frame(maxHeight: 1)
            
            List {
                
                ForEach(slaveValues){ item in
                    SlaveCellView(fileName: item.fileName, createdTime: item.createdTime)
                }
                
            }.navigationBarHidden(true)
            
            Spacer()
            
        }
        .background(Color.aDarkGreyBackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SlaveCellView: View {
    
    @State var fileName: String
    @State var createdTime: String
    
    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 5.0)
                .fill(Color.white)
                .frame(height: 80)
            VStack(alignment: .leading){
                Text(fileName)
                    .foregroundColor(.black)
                    .font(.heleveticNeueLight(size: 17))
                Text(createdTime)
                    .foregroundColor(.black)
                    .font(.heleveticNeueLight(size: 13))
            }
            .padding(.leading,10)
            .padding(.trailing,10)
        }.frame(minWidth: 0, maxWidth: .infinity)
       
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
            
                MasterBottomLayout()
            
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

struct MasterBottomLayout: View {
    
    var body: some View {
     
        VStack(alignment: .center, content: {
            Text("Tip: Print sample entry tags and receipts for scanning").foregroundColor(.black).bold()
            Text("Visit www.fairsoftware.com/samples to print out sample entry tags and receipts which have QR Codes (barcodes) on them, allowing you to see how the scanner works which makes locating entries even faster.").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        })
        .padding(.leading,100)
        .padding(.trailing,100)
    }
}

struct SlaveTopLayout: View {
    
    var body: some View {
     
        HStack{
            Button(action: {
                   print("Settings")
               }, label: {
                   Text("Settings")
                   .font(.heleveticNeueLight(size: 15))
                   .foregroundColor(Color.blue)
            })
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Text("Sheets (10)").foregroundColor(.black).bold()
            Spacer()
            Button(action: {
                   print("Sort")
               }, label: {
                   Text("Sort")
                       .font(.heleveticNeueLight(size: 15))
                       .foregroundColor(Color.blue)
                       .background(Color.aDarkGreyBackgroundColor)
            })
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.top,10)
        .padding(.leading,10)
        .padding(.trailing,10)
    }
}
