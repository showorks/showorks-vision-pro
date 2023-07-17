//
//  ShoWorksLogo.swift
//  ShoWorks
//
//  Created by Lokesh on 13/07/23.
//

import SwiftUI

struct ShoWorksLogo: View {
    var body: some View {
        Image("SplashLogo")
            .resizable()
            .frame(width: 180, height: 196, alignment: .center)
    }
}

#Preview {
    ShoWorksLogo()
}



// Extension for hidden
extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
