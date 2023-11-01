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
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity( isCheckIn ? 0.1 : 0.3))
                .frame(width: 340, height: 45)
            
            VStack(alignment: .leading){
                Text(text1)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity( isCheckIn ? 0.4  : 0.9))
                    .fontWeight(.light)
                Text(text2)
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(isCheckIn ? 0.6 : 1))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        }
        .frame(width: 340)
    }
}


struct LeftViewBox: View {
    
    var width: CGFloat
    var height: CGFloat
    
    var text: String
    var heading: String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.2))
                .frame(width: width, height: height)
            
            VStack(alignment: .leading, spacing: 5){
                Spacer()
                HStack{
                    Circle().fill(.white).frame(width: 10)
                    Text(heading)
                        .fontWeight(.light)
                }
                
                Text("   \(text)")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.bottom)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.leading)
            
            
        }
        .frame(width: width, height: height)
    }
}

extension HomeTabLayout{
    @ViewBuilder
    var leftView: some View{
        VStack(spacing: 15){
            
            LeftViewBox(width: 500, height: 100, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].exhibitor, heading: "Exhibitor")
            HStack(spacing: 20){
                
                LeftViewBox(width: 240, height: 140, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].department, heading: "Department")
                LeftViewBox(width: 240, height: 140, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].club, heading: "Club")
            }
            
            HStack(spacing: 20){
                LeftViewBox(width: 240, height: 140, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].entryNumber, heading: "Entry Number")
                LeftViewBox(width: 240, height: 140, text: DataCenter.sharedInstance.searchedRecords[currentSearchCount].wen, heading: "WEN")
            }
            
        }
        .frame(width: 570)
    }
    
    @ViewBuilder
    var rightView: some View{
        ZStack{
            Color.black.opacity(0.3)
            
            VStack(spacing: 8){
                
                Text("Tap any text below to make changes")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 12))
                    .fontWeight(.light)
                RightViewBox(isCheckIn: $isCheckIn, text1: "Divion", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].division)
                RightViewBox(isCheckIn: $isCheckIn, text1: "Class", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].Class)
                RightViewBox(isCheckIn: $isCheckIn, text1: "Description", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].description)
                RightViewBox(isCheckIn: $isCheckIn, text1: "Validation Number", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].validationNumber)
                RightViewBox(isCheckIn: $isCheckIn, text1: "Entry Validation Date", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].entryValidationDate)
                RightViewBox(isCheckIn: $isCheckIn, text1: "State Fair", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].stateFair)
                
                HStack{
                    Text("For Sale")
                        .font(.system(size: 12))
                        .fontWeight(.light)
                    Spacer()
                    Toggle("", isOn: $forSaleToggle)
                        .disabled(isCheckIn)
                        .frame(height: 30)
                }
                
                RightViewBox(isCheckIn: $isCheckIn, text1: "Sale Price ($)", text2: DataCenter.sharedInstance.searchedRecords[currentSearchCount].salePrice)
            }
            .frame(width: 340)
            
//            if !isCheckIn{
//                Color.white.opacity(0.3)
//            }
        }
    }
}
