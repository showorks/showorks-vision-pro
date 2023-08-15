//
//  KioskWelcomeView.swift
//  ShoWorks
//
//  Created by Lokesh on 15/08/23.
//

import SwiftUI

struct KioskWelcomeView: View {

    @EnvironmentObject var viewModel: KioskViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                CustomBackground()
                    .edgesIgnoringSafeArea(.all)
                
                Text(viewModel.homeViewSelectedData?.fileName ?? "")
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    KioskWelcomeView()
}
