//
//  Fonts.swift
//  ShoWorks
//
//  Created by Lokesh on 17/07/23.
//

import Foundation
import SwiftUI
extension Font {
    
    static func heleveticNeueLight(size: CGFloat) -> Font {
        Font.custom("HelveticaNeue-Light", size: size)
    }
    
    static func heleveticNeueThin(size: CGFloat) -> Font {
        Font.custom("HelveticaNeue-Thin", size: size)
    }

    static func heleveticNeueBold(size: CGFloat) -> Font {
        Font.custom("HelveticaNeue-Bold", size: size)
    }

    static func heleveticNeueCondensedBold(size: CGFloat) -> Font {
        Font.custom("HelveticaNeue-CondensedBold", size: size)
    }
    
    static func heleveticNeueMedium(size: CGFloat) -> Font {
        Font.custom("HelveticaNeue-Medium", size: size)
    }
}
