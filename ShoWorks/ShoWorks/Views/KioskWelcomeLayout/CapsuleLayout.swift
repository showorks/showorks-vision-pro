//
//  CapsuleLayout.swift
//  iPadSingleScreen
//
//  Created by Lokesh Rawat on 17/10/23.
//

import SwiftUI

struct CapsuleLayout < T: View >: View {
    
    var extendedView: () -> T
    var isNumber: Bool
    @State var showCapsuleElements: Bool = false
    @State var capsuleWidth: CGFloat = 110
    
    #if !os(xrOS)
    @State var maxCapsuleWidth: CGFloat = UIScreen.main.bounds.width * 0.56
    #endif
    
    #if os(xrOS)
    @State var maxCapsuleWidth: CGFloat = 1355 * 0.56
    #endif
    
    init( isNumberStack: Bool , @ViewBuilder extendedView: @escaping () -> T){
        self.extendedView = extendedView
        isNumber = isNumberStack
    }
    
    var body: some View {
        ZStack{
            
            HStack{
                Capsule().fill(.white.opacity(0.92))
                    .frame(width: capsuleWidth, height: 70)
                Spacer()
            }
            
                
            
            if showCapsuleElements{
                HStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        
//                        hstack below are the items when extended.
                        extendedView()
                        
                        
                        
                    }
                    .frame(width: capsuleWidth - 50)
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)){
                                capsuleWidth = 110
                            }

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                showCapsuleElements = false
                            }
                        }
                }
            }else{
//                collapsed stack
                HStack{
//                    collapsedView()
                    if isNumber{
                        ZStack{
                            Circle().stroke(.black, lineWidth: 3).frame(width: 50)

                            Text("9")
                                .font(.system(size: 19))
                        }
                        
                    }else{
                        ZStack{
                            Circle().fill(.white).frame(width: 50)

                            Image(systemName: "bolt.heart.fill")
                                .font(.system(size: 19))
                        }
                    }
//                    UIDevice.current.userInterfaceIdiom == .
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    
                }
                .padding(.leading)
                .onTapGesture {
                    if !showCapsuleElements{
                        withAnimation(.easeInOut(duration: 0.5)){
                            capsuleWidth = maxCapsuleWidth
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            showCapsuleElements = true
                        }
                    }
                }
                
            }
            
            
        }
        .frame(width: maxCapsuleWidth)
    }
}

//struct CapsuleView2_Previews: PreviewProvider {
//    static var previews: some View {
//        CapsuleView2(collapsedView: VStack{Text("anc")}, extendedView: Text("gahg"))
//    }
//}
