//
//  ShoWorksLogo.swift
//  ShoWorks
//
//  Created by Lokesh on 13/07/23.
//

import SwiftUI

struct ShoWorksLogo: View {
  
    @State private var progress: CGFloat = 0.0

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Image("showorks_logo_new")
                .frame(alignment: .center)
            ZStack(alignment: .leading) {
                  Rectangle()
                    .frame(width: 250, height: 20)
                    .opacity(0.3)
                    .cornerRadius(5)
                    .foregroundColor(.gray)

                  Rectangle()
                    .frame(width: progress * 250, height: 20)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .animation(.easeInOut, value: progress)
                }
                .padding(.top,50)
                .onReceive(timer) { _ in
                  if progress < 1.0 {
                    progress += 0.01
                  }
                }
        }
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
