//
//  HeaderAndFooter.swift
//
//  Created by Lokesh Sehgal on 17/10/23.
//

import Foundation
import SwiftUI

extension KioskWelcomeNewView{
    @ViewBuilder
    var headerAndFooter: some View{
        
        VStack{
//            header
            HStack(spacing: 10){
                Button {
                    print("header button 1 tap")
                } label: {
                    
                    ZStack{
                        Circle().fill(.white).frame(width: 30)
                        Circle().fill(.black).frame(width: 15)
                    }
                    
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                
                HStack(spacing: 20){
                    Button {
                        print("header button 2 tap")
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.black)
                            .fontWeight(.bold)
                            .font(.system(size: 35))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        print("header button 3 tap")
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        print("header button 4 tap")
                    } label: {
                        Image(systemName: "questionmark.square.fill")
                            .foregroundColor(.black)
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                    }
                    .buttonStyle(PlainButtonStyle())

                    
                    
                }
            }
            
            Divider().overlay{
                Color.white.opacity(0.4)
            }
            Spacer()
            
//            footer page numbers
            
            ZStack{
//                Capsule().fill(.white).frame(width: capsuleWidth, height: 60)
                
                CapsuleLayout(isNumberStack: true) {
                    HStack{
                        ForEach(1..<31){num in
                            
                            Button {
                                print("\(num)")
                            } label: {
                                ZStack{
                                    Circle().stroke(.black, lineWidth: 1)
                                        .frame(width: 40)
                                    Text("\(num)")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                }
//                HStack{
//                    ScrollView(.horizontal, showsIndicators: false){
//                        HStack{
//                            ForEach(1..<31){num in
//
//                                Button {
//                                    print("\(num)")
//                                } label: {
//                                    ZStack{
//                                        Circle().stroke(.black, lineWidth: 1)
//                                            .frame(width: 40)
//                                        Text("\(num)")
//                                            .fontWeight(.bold)
//                                            .foregroundColor(.black)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
            }
            .padding(.bottom, 30)
            
        }
        .frame(width: deviceWidth * 0.56)
        
    }
}
