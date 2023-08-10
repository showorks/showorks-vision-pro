//
//  HomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI
import UIKit


struct HomeViewData: Identifiable,Hashable {
    let id = UUID()
    var fileName: String
    var createdTime: String
    var numberOfDepartments: String
    var numberOfClasses: String
    var numberOfDivisions: String
    var numberOfEntries: String
}

struct HomeView: View {
         
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel

    @State var alertItem: AlertItem?
    
    @State var aUserName: String = ""
    
    @State var mScreenState: AppConstant.AppStartupStatus?
    @State var mSelectedOption: HomeViewData?

    @ObservedObject var homeViewModel = HomeViewModel()
    
    var body: some View {
     
        ZStack{
            ShoWorksBackground()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HomeTitleLayout(aUserName: $aUserName)
                NavigationSplitView {
                    
                    
                    SlaveLayout(slaveValues:self.$homeViewModel.listItems,mSelectedOption: $mSelectedOption)
                            .border(Color.aSeperatorColor)
                }
                detail: {
                    MasterLayout(mSelectedOption: $mSelectedOption)
                        .navigationBarHidden(true)
                        .border(Color.aSeperatorColor)
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
            if mScreenState == .demoMode {
                aUserName = "demo_mode".localized()
                
            }else{
                aUserName = UserSettings.shared.firstName ?? "demo_mode".localized()
            }
            
            loadDataOnScreen()
        }
        
    }
    
    func loadDataOnScreen(){
        
        if viewModel.authenticationResponse == nil {
                loadPlistData()
        }else{
            Task {
                DataCenter.sharedInstance.setupWithAccessKey(_accessKey: UserSettings.shared.accessKey, andSecretKey: UserSettings.shared.secretKey) { downloadCompleted in
                    if downloadCompleted {
                        loadPlistData()
                    }
                }
            }
        }
    }
    
    func loadPlistData(){
        Task {
            await homeViewModel.loadPlistArrayWithSheetsDetailData(screenType: mScreenState ?? .demoMode)
        }
    }
}

#Preview {
    HomeView()
}



struct HomeTitleLayout: View {
    @Binding var aUserName: String
    var body: some View {
            
        HStack(){
            Text("welcome_new".localized() + " " + aUserName).font(.heleveticNeueBold(size: 25))
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
    
    @Binding var slaveValues: [HomeViewData]?
    
    @Binding var mSelectedOption: HomeViewData?
    @State private var searchText: String = ""

    var body: some View
    {
        VStack {
            SlaveTopLayout(aTextValue: Binding.constant(String.init(format: "Sheets (%ld)", slaveValues?.count ?? 0)))
            
            Divider().frame(maxWidth: .infinity,maxHeight: 2)
                .background(Color.aSeperatorColor)
            
            SearchBar(text: $searchText)
            
            List(slaveValues ?? [], id: \.self, selection: $mSelectedOption) { item in
                SlaveCellView(fileName: item.fileName, createdTime: item.createdTime)
                    .listRowSeparatorTint(.gray)
                    .listRowBackground(item == mSelectedOption ? Color.aLightGrayColor : Color.white)

            
            }
            
//            .listStyle(.plain)
            .padding(.bottom,100)
            .navigationBarHidden(true)
            .listRowSeparator(.hidden)
            .onAppear { UITableView.appearance().separatorStyle = .none }
//            Spacer()
            SlaveBottomLayout()
                .padding(30)
                .offset(y:-120)
        }

        .background(Color.aHomeBackgroundColor)
        .edgesIgnoringSafeArea(.all)
    }
}

struct SlaveCellView: View {
    
    @State var fileName: String
    @State var createdTime: String
    
    var body: some View {

        VStack(alignment: .leading){
                Text(fileName)
                    .foregroundColor(.black).font(.heleveticNeueBold(size: 16))
                Spacer().frame(height: 2)
            
                Text("created_on".localized() + " " + createdTime)
                    .foregroundColor(.black)
                    .font(.heleveticNeueLight(size: 12))
            
                Rectangle()
                .stroke(Color.clear, lineWidth: .infinity).frame(height: 1)

            }
            .padding(.leading,10)
            .padding(.top,4)
            .padding(.trailing,10)
            .frame(minWidth: 0, maxWidth: .infinity,maxHeight: 60)
       
    }
}

struct MasterLayout: View {
    
    @Binding var mSelectedOption: HomeViewData?
    
    var body: some View {
            
        VStack {

                MasterTopLayout(mSelectedOption: $mSelectedOption)
                MasterCenterLayout(mSelectedOption: $mSelectedOption)
                HStack(){
                    
                    Text("go_to_sheet".localized())
                        .font(.system(size: 20))
                        .padding(.init(top: 30, leading: 50, bottom: 30, trailing: 50))
                        .foregroundColor(Color.white)
                        .background(Color.aBlueBackgroundColor)
                        .cornerRadius(5)
                    
                }.padding(40)
            
                MasterBottomLayout()
            
                Spacer()
               }
                   .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                   .background(Color.aHomeBackgroundColor)
                   .edgesIgnoringSafeArea(.all)
    }
}

struct MasterTopLayout: View {
    
    @Binding var mSelectedOption: HomeViewData?
    
    var body: some View {
        VStack(){
            Text(mSelectedOption?.fileName ?? "").foregroundColor(.black)
                .font(.heleveticNeueBold(size: 17))
            .padding(.top,10)
        
            Rectangle()
            .stroke(Color.aSeperatorColor, lineWidth: 1).frame(maxHeight: 1)

            HStack(){
                Text("sheet_properties".localized()).foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 15))
                Spacer()
            }
            .padding(.top,30)
            .padding(.leading,30)
            HStack(){
                Text("Created on Mon 1 Jul at 2:33 PM").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 15))
                Spacer()
                Text("Updated on Mon 30 Sept at 3.52 PM").foregroundColor(.aTextGrayColorSheetProperties).font(.heleveticNeueMedium(size: 15))
            }
            .padding(.leading,30)
            .padding(.trailing,30)
        }
        
    }
}

struct MasterCenterLayout: View {

    @Binding var mSelectedOption: HomeViewData?

    var body: some View {
        VStack(){
            MasterCenterRowLayout(aTextTitle: "num_departments".localized(), aTextValue: Binding.constant(self.mSelectedOption?.numberOfDepartments ?? " "))
                .padding(3)
            
            Divider().background(Color.aSeperatorColor)
            
            MasterCenterRowLayout(aTextTitle: "num_divisions".localized(), aTextValue: Binding.constant(self.mSelectedOption?.numberOfDivisions ?? " "))
                .padding(3)

            Divider().background(Color.aSeperatorColor)
            
            MasterCenterRowLayout(aTextTitle: "num_classes".localized(), aTextValue: Binding.constant(self.mSelectedOption?.numberOfClasses ?? " ")).padding(3)

            
            Divider().background(Color.aSeperatorColor)

            MasterCenterRowLayout(aTextTitle: "num_entries".localized(), aTextValue: Binding.constant(self.mSelectedOption?.numberOfEntries ?? " ")).padding(3)


        }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(20)
            .background(.white)
            .cornerRadius(5) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.aSeperatorColor, lineWidth: 0.5)
            )
            .padding(.leading,30)
            .padding(.trailing,30)
    }
}

struct MasterCenterRowLayout: View {
    
    @State var aTextTitle: String
    @Binding var aTextValue: String
    
    var body: some View {
     
        HStack(){
            Text(aTextTitle).foregroundColor(.black).font(.heleveticNeueMedium(size: 18))
            Spacer()
            Text(aTextValue).foregroundColor(.aTextGrayColor).font(.heleveticNeueMedium(size: 18))
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct MasterBottomLayout: View {
    
    var body: some View {
     
        VStack(alignment: .center, content: {
            Text("tip_message".localized()).foregroundColor(.black).font(.heleveticNeueBold(size: 16))
            Text("Visit www.fairsoftware.com/samples to print out sample entry tags and receipts which have QR Codes (barcodes) on them, allowing you to see how the scanner works which makes locating entries even faster.").foregroundColor(.aTextGrayColor).font(.heleveticNeueLight(size: 15))
        })
        .padding(.leading,100)
        .padding(.trailing,100)
    }
}

struct SlaveTopLayout: View {
    @Binding var aTextValue: String
    var body: some View {
     
        HStack{
            Button(action: {
                   print("settings pressed")
               }, label: {
                   Text("settings_btn".localized())
                       .font(.heleveticNeueBold(size: 16))
                   .foregroundColor(Color.blue)
            })
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Text(aTextValue).foregroundColor(.black).bold()
            Spacer()
            Button(action: {
                   print("Sort pressed")
               }, label: {
                   Text("sort_btn".localized())
                       .font(.heleveticNeueBold(size: 16))
                       .foregroundColor(Color.blue)
                       .background(Color.aHomeBackgroundColor)
            })
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.top,10)
        .padding(.leading,10)
        .padding(.trailing,10)
    }
}

struct SlaveBottomLayout: View {
    
    @State private var progress = 0.2
       
    var body: some View {
        VStack{
            Divider()
                    .frame(maxWidth: .infinity,maxHeight: 1)
                    .background(Color.aSeperatorColor)
            
            HStack {
                
                ProgressView(value: progress) {
                    Text("Updated on Mon 3 Jul at 5:20 PM").font(.heleveticNeueMedium(size: 12))
                    //Updated on Mon 3 Jul at 5:20 PM
                } currentValueLabel: {
                    Text("Syncing Sheets: 2/10").font(.heleveticNeueMedium(size: 10))
                }
                .foregroundColor(Color.black)
            }.padding(.top,5)
        }
//        .progressViewStyle(.circular)
    }
}


struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.white)
                .foregroundColor(Color.black)
                .cornerRadius(8)
                .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
             
                    if isEditing {
                        Button(action: {
                            self.text = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                
            }
        }
    }
}
