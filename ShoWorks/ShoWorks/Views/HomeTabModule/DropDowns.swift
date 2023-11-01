//
//  DropDowns.swift
//  VisionOSScreens
//
//  Created by Lokesh Sehgal on 28/10/23.
//

import SwiftUI


enum DropDownType{
    case place, ribbon, none
}

struct DropDown: View {
    
    var imageName: String
    var dropDownType: DropDownType
    
    
    @Binding var selectedDropDown: DropDownType
    @Binding var selectedOption: String
    @Binding var isCheckIn: Bool
    
    
    var body: some View {
        ZStack{
            if isCheckIn{
                Capsule().stroke(.white.opacity(0.5))
                    .frame(width: 140, height: 35)
            }else{
                Capsule().fill(.white.opacity(0.8))
                    .frame(width: 140, height: 35)
            }
            
            HStack(spacing: 6){
                
                if isCheckIn{
                    Color.white.opacity(0.6).frame(width: 15, height: 15)
                        .mask {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12)
                        }
                }else{
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                }
                
                
                Text(selectedOption)
                    .font(.system(size: 12))
                Image(systemName: dropDownType == selectedDropDown ? "chevron.up" : "chevron.down")
                    .font(.system(size: 10))
                
            }
            .foregroundStyle( isCheckIn ? .white.opacity(0.5) : .black)
        }.isHidden(isCheckIn)
        
        
    }
}

struct DropDownOption: View {
    
    var imageName: String = ""
    @Binding var selectedOption: String
    var text: String
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(.white.opacity(0.001))
                .frame(width: 170, height: 38)
                .glassBackgroundEffect()
                
            HStack(spacing: 10){
                
                if imageName == "Place"{
                    Color.white.frame(width: 15, height: 15)
                        .mask {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                        }
                }else{
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                }
                
                
                
                
                Text(text)
                    .font(.system(size: 10))
                    .onTapGesture {
                        selectedOption = text
                    }
                Spacer()
                
                if selectedOption == text{
                    Image(systemName: "checkmark")
                        .padding(.trailing)
                }
            }
            .padding(.leading, 10)
        }
        .onAppear(perform: {
            print(text)
        })
        .frame(width: 170, height: 38)
        
    }
}


extension HomeTabLayout{
    @ViewBuilder
    var dropDowns: some View{
        ZStack{
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        HStack{
                            DropDown(imageName: "Place", dropDownType: .place, selectedDropDown: $dropDownType, selectedOption: $selectedPlace, isCheckIn: $isCheckIn)
                                .onTapGesture {
                                    if isCheckIn{
                                        return
                                    }
                                    
                                    if dropDownType != .place{
                                        dropDownType = .place
                                    }else{
                                        dropDownType = .none
                                    }
                                    
                                }
                            DropDown(imageName: "Ribbon", dropDownType: .ribbon, selectedDropDown: $dropDownType, selectedOption: $selectedRibbon, isCheckIn: $isCheckIn)
                                .onTapGesture {
                                    if isCheckIn{
                                        return
                                    }
                                    if dropDownType != .ribbon{
                                        dropDownType = .ribbon
                                    }else{
                                        dropDownType = .none
                                    }
                                }
                        }
                        
                        if dropDownType == .place{
                            ZStack{
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                        .frame(width: 190, height: 240)
                                        
                                        
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(.white.opacity(0.5))
                                        .frame(width: 190, height: 240)
                                }.clipShape(RoundedRectangle(cornerRadius: 10))
                                ScrollView() {
                                    LazyVStack{
                                        HStack{}.frame(height: 5)
                                        ForEach(1..<100, id: \.self){num in
//                                            if num == 1{
//                                                DropDownOption(imageName: "Place", selectedOption: $selectedPlace, text: "1st Place")
//                                            }else if num == 2{
//                                                DropDownOption(imageName: "Place",selectedOption: $selectedPlace, text: "2nd Place")
//                                            }else if num == 3{
//                                                DropDownOption(imageName: "Place",selectedOption: $selectedPlace, text: "3rd Place")
//                                            }else{
                                                DropDownOption(imageName: "Place",selectedOption: $selectedPlace, text: "\(num)th Place")
//                                            }
                                            
                                        }
                                    }
                                    
                                }
                                .scrollIndicators(.never)
                                .frame(width: 190, height: 240)
                                .clipShape(Rectangle())
                                .padding(.vertical, 6)
                                
//                                VStack(spacing: 6){
//                                    
//                                }.frame(width: 190, height: 240)
                            }
                            .frame(width: 190, height: 240)
                            .offset(x: -30)
                        }
                        else if dropDownType == .ribbon{
                            ZStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
    //                                    .blur(radius: 1)
                                        .frame(width: 190, height: 220)
                                        
                                        
                                    
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(.white.opacity(0.5))
                                        .frame(width: 190, height: 220)
                                }.clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                VStack{
                                    ScrollView {
                                        HStack{}.frame(height: 6)
                                        ForEach(ribbonArray, id: \.self){rib in
                                            DropDownOption(imageName: rib ,selectedOption: $selectedRibbon, text: rib)
                                        }
                                    }
                                    .scrollIndicators(.never)
                                    .padding(.vertical, 6)
                                }
                            }
                            .frame(width: 190, height: 220)
                            .offset(x: 30)
                        }
                        
                        
                    }
                    
                }
                Spacer()
            }
            .padding(.trailing, 20)
            .padding(.top, 11)
            
            if dropDownType != .none{
                Color.white.opacity(0.01)
                    .onTapGesture {
                        dropDownType = .none
                    }
            }
        }
        
    }
}
