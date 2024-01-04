//
//  ScreenData.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import Foundation
import SwiftUI

struct RightViewBox: View {
    
    @Binding var isCheckIn: Bool

    var text1: String
    var text2: String
    @State var allowEditing: Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity( !allowEditing ? 0.1 : 0.3))
                .frame(width: 340, height: 45)
           
            VStack(alignment: .leading){
                Text(text1)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity( !allowEditing ? 0.4  : 1))
                    .fontWeight(.light)
                Text(text2.count == 0 ? "-" : text2.trim())
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(!allowEditing ? 0.6 : 1))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        }
        .frame(width: 340)
    }
}


struct RightViewDescriptionBox: View {
    
    @Binding var isCheckIn: Bool

    var userInputtedDescription: String
    var userInputtedTitle: String
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.3))
                .frame(width: 340, height: 45)
         
            VStack(alignment: .leading){
                Text(userInputtedTitle)
                    .font(.system(size: 12))
                    .foregroundStyle(userInputtedDescription.isEmpty ? .red : .white)
                    .fontWeight(userInputtedDescription.isEmpty ? .bold : .light)
                
                HStack{
                    Text(userInputtedDescription.isEmpty ? "-" : userInputtedDescription)
                        .font(.system(size: 15))
                        .foregroundStyle(.white)
                    
//                    if userInputtedDescription.isEmpty {
                        
                        Spacer()
                        
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 18))
                            .hoverEffect(.lift)
                            .foregroundStyle(.white).padding(.trailing,10)
//                    }
                }
                
                
                
//                pencil
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        }
        .frame(width: 340)
        
//        ZStack{
//            RoundedRectangle(cornerRadius: 8)
//                .fill(.white.opacity(0.3))
//                .frame(width: 330, height: 45)
//           
//            VStack(alignment: .leading){
//                
//                TextField(text: $userInputtedDescription) {
//                    
//                } .font(.system(size: 15))
//                    .frame(width: 340)
//                    .cornerRadius(4)
//                    .textFieldStyle(.plain)
//                    .multilineTextAlignment(.leading)
//                    .foregroundColor(userInputtedDescription.isEmpty ? Color.red : Color.white)
//                
//                    TextField("Enter Description", text: $userInputtedDescription)
////                        .placeholder(when: userInputtedDescription.isEmpty) {
////                            Text("Enter Description").foregroundColor(.red)
////                                                   .multilineTextAlignment(.leading)
////                                                   .font(.system(size: 12))
////                                                   .frame(width: 340)
////                        }
//                       
//                
//                
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, 10)
//        }
//        .frame(width: 340)
    }
}



struct LeftViewBox: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var text: String
    var heading: String
    @State private var displayBottomSheet = false
    
    var body: some View {
        VStack{
            Text(heading)
                .font(.sfProLight(size: 16))
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            ZStack{
                RoundedRectangle(cornerRadius: 16).fill(.white.opacity(0.2))
                    .frame(width: width, height: height)
                
                VStack(alignment: .leading, spacing: 5){

    //                HStack{
    ////                    Circle().fill(.white).frame(width: 10)
    //                    Text(heading)
    //                        .font(.sfProLight(size: 14))
    //                }
                    
                    Text(text.count == 0 ? "-" : "\(text)")
                        .font(.heleveticNeueBold(size: 24))
                        .padding(10)
                        .lineLimit(2)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.leading)
                
                
            }
            .onTapGesture {                
                if heading == "Department" {
                    displayBottomSheet.toggle()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationDepartmentTapped), object: nil)
                }else if heading == "Division" {
                    displayBottomSheet.toggle()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationDivisionTapped), object: nil)
                }else if heading == "Class" {
                    displayBottomSheet.toggle()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConstant.NotificationClassTapped), object: nil)
                }
            }
            .sheet(isPresented: $displayBottomSheet) {
                        List(1...20, id: \.self) { index in
                               Text("Item \(index)")
                           }
                        .onTapGesture {
                            displayBottomSheet.toggle()
                        }
                            .presentationDetents([ .medium, .large])
                                     .presentationBackground(.thinMaterial)
                                     .presentationCornerRadius(50)
                                     .presentationBackgroundInteraction(.enabled)
                    }
        }
        .frame(width: width, height: height)
    }
}

extension HomeTabLayout{
    @ViewBuilder
    var leftView: some View{
        VStack(spacing: 15){
            
            if isCheckIn {
                
                LeftViewBox(width: 620, height: 60, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].exhibitor, heading: "Exhibitor")
                Spacer().frame(maxHeight: 20)
                HStack(spacing: 20){
                    
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].department, heading: "Department")
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].division, heading: "Division")
                }
                Spacer().frame(maxHeight: 20)
                HStack(spacing: 20){
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].Class, heading: "Class")
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].entryNumber, heading: "Entry Number")
                }
            }
            else{
                
                LeftViewBox(width: 620, height: 60, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].exhibitor, heading: "Exhibitor")
                Spacer().frame(maxHeight: 20)
                HStack(spacing: 20){
                    
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].division, heading: "Division")
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].Class, heading: "Class")
                    
                }
                Spacer().frame(maxHeight: 20)
                HStack(spacing: 20){
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].department, heading: "Department")
                    LeftViewBox(width: 300, height: 120, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].division, heading: "Sheet Name")
                }
            }
            
            
        }
        .frame(width: 670)
    }
    
    @ViewBuilder
    var rightView: some View{
        var testingCheckinMode = true
        ZStack{
            Color.black.opacity(0.3)
            
            VStack(spacing: 8){
                
                Spacer().frame(maxHeight: 40)
                
                Text("Tap any cell below to make any changes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                    
                if isCheckIn {
                        RightViewDescriptionBox(isCheckIn: $isCheckIn, userInputtedDescription: DataCenter.sharedInstance.searchedRecords[currentSearchCount].descriptionInfo,userInputtedTitle: "Description")
                        
                        RightViewDescriptionBox(isCheckIn: $isCheckIn, userInputtedDescription: DataCenter.sharedInstance.searchedRecords[currentSearchCount].validationNumber,userInputtedTitle: "Validation Number")
                        
                        RightViewBox(isCheckIn: $isCheckIn, text1: "Entry Validation Date", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].entryValidationDate,allowEditing: testingCheckinMode ? true : false)
                        RightViewBox(isCheckIn: $isCheckIn, text1: "State Fair", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].stateFair,allowEditing: testingCheckinMode ? true : false)
                        
                        HStack{
                            Text("For Sale")
                                .font(.system(size: 12))
                                .fontWeight(.light)
                            Spacer()
                            Toggle("", isOn: $forSaleToggle)
                                .disabled(isCheckIn ? false : true)
                                .isHidden(isCheckIn ? false : true)
                                .frame(height: 30)
                        }
                        
                        RightViewBox(isCheckIn: $isCheckIn, text1: "Sale Price ($)", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].salePrice,allowEditing: testingCheckinMode ? true : false)
                        
                        Spacer()
                }else{
                  
                            RightViewDescriptionBox(isCheckIn: $isCheckIn, userInputtedDescription: "Best of Show",userInputtedTitle: "Special PI")
                    
                            RightViewDescriptionBox(isCheckIn: $isCheckIn, userInputtedDescription: "Champion",userInputtedTitle: "Division PI")
                                        
                            RightViewBox(isCheckIn: $isCheckIn, text1: "Animal", text2: "British",allowEditing: false)
                    
                            RightViewBox(isCheckIn: $isCheckIn, text1: "B/W/H", text2: String(Int.random(in: 1100..<1200)),allowEditing: false)
                    
                            RightViewBox(isCheckIn: $isCheckIn, text1: "Tag", text2: String(Int.random(in: 1..<900)),allowEditing: false)
                    
                    
                            HStack(spacing: 5) {
                                
                                
                                Text(String("6"))
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .padding()
                                    .overlay(
                                        Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .padding(10)
                                    )
                                
                                
                                
                                Image("Green Ribbon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                
                            }
                            .padding(.top,15)
                            .frame(width: 340, height: 120)
                            
                    
                            Spacer()
                     
                }
            }
            .frame(width: 340)
            
//            if !isCheckIn{
//                Color.white.opacity(0.3)
//            }
        }
    }
}
