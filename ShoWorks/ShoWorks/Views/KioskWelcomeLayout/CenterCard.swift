//
//  CenterCard.swift
//  iPadSingleScreen
//
//  Created by Lokesh Sehgal on 17/10/23.
//

import Foundation
import SwiftUI

extension KioskWelcomeNewView{
        @ViewBuilder
        var centerCard: some View{
            ZStack{
                Rectangle().fill(.white.opacity(0.92))
                    .frame(width: deviceWidth * 0.56, height: 380)
                    .cornerRadius(30)
                VStack{
                    
    //                        card header
                    
                    HStack{
    //                            class name
                        HStack{
                            Text("Class Name")
                                .font(.system(size: 37))
                                .fontWeight(.bold)
                            
                            ZStack{
                                Capsule().fill(.yellow).frame(width: 50, height: 33)
                                Text("7th")
                            }
                            
                        }
                        
                        Spacer()
    //                    check in and undo
                        HStack{
                            
                            Button {
                                print("check in tap")
                            } label: {
                                ZStack{
                                    Rectangle().fill(.cyan).frame(width: 100, height: 50)
                                        .cornerRadius(8)
                                    Text("Check In")
                                        .foregroundColor(.black)
                                }
                            }
                            
                            Button {
                                print("undo tap")
                            } label: {
                                ZStack{
                                    Rectangle().fill(.white).frame(width: 60, height: 50)
                                        .cornerRadius(8)
                                    Text("Undo")
                                        .foregroundColor(.black)
                                }
                            }
                            
                        }
                        .font(.system(size: 16))
                    }
                    .padding(.horizontal, 40)
                    
                    Divider()
                        .offset(y: -10)
                    
    //                        name
                    HStack(spacing: 15){
                        ZStack{
                            Circle().fill(.blue).frame(width: 50)
                        }
                        Text("Diksha Khemlami")
                            .font(.system(size: 25))
                            .fontWeight(.semibold)
                        Spacer()
                    }.padding(.leading, 30)
                        .padding(.bottom, 15)
                    
    //                        grid
                    Grid(horizontalSpacing: 13, verticalSpacing: 13){
                        GridRow(){
                            SubCard(title: "Dept", value: "Dept Name")
                            SubCard(title: "Entry Number", value: "275")
                            SubCard(title: "WEN", value: "7DV5ACG")
                            SubCard(title: "Class", value: "3rd Class")
                        }
                        GridRow{
                            SubCard(title: "Date", value: "02 Sep, 2023")
                            SubCard(title: "Place", value: "31")
                            SubCard(title: "Club", value: "Joy Ride")
                            SubCard(title: "Ribbon Colour", value: "Blue")
                        }
                    }
                }
                
            }
            .frame(width: deviceWidth * 0.56)
            
            
        }
    }



    struct SubCard: View{
        
        #if !os(xrOS)
        var width = (UIScreen.main.bounds.width * 0.56 * 0.25) - 25
        #endif
        
        #if os(xrOS)
        var width = (1355 * 0.56 * 0.25) - 25
        #endif
        
        var title: String
        var value: String
        
        var body: some View{
            ZStack{
                Rectangle().fill(.white).frame(width: width, height: 75)
                    .cornerRadius(6)
                
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text(title)
                            .foregroundColor(.gray)
                            .font(.system(size: 10))
                        Text(value)
                            .font(.system(size: 17))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.trailing)
                        
                }
                
                
            }
            .frame(width: width)
        }
    }
