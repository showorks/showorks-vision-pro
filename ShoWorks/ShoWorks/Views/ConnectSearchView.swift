//
//  ConnectSearchView.swift
//  ShoWorks
//
//  Created by Lokesh on 29/10/23.
//

import SwiftUI

struct ConnectSearchView: View {
    @EnvironmentObject var viewModel: ShoWorksAuthenticationModel

    @State var mScreenState: AppConstant.AppStartupStatus?
    
    var body: some View {
        ZStack(){
            
            VStack(alignment: .center, content: {
              
                Image("scanner_gun")
                        .resizable()
                        .frame(width: 100,height: 100)
                        .frame(alignment: .center)
                
                Text("Connect to a Handheld scanner".localized())
                    .fontWeight(.bold)
                    .padding(.top,10)
                    .font(.sfProRegular(size: 26))
                    
                
                Text("to start scanning entries for judging or check-in".localized()).font(.sfProRegular(size: 16))
                    .foregroundColor(.white)
                
                Text("or_text".localized()).font(.sfProLight(size: 15))
                    .foregroundColor(.white).padding(.top,25).padding(.bottom,25)
                
                Text("Manual Search")
                    .font(.sfProRegular(size: 14))
                    .padding(10)
                    .frame(width: 200)
                    .background(Image("manual_search"))
                    .foregroundColor(Color.white)
                    .cornerRadius(25)
                    .onTapGesture {
                       
                    }
                
            }).padding(50)
//                .background( VisualEffectBlur(blurStyle: .extraLight)
//                    .ignoresSafeArea())
//                .cornerRadius(20)
                        
        }
    }
}

#Preview {
    ConnectSearchView()
}
