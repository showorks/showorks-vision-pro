//
//  LazyView.swift
//  ShoWorks
//
//  Created by Lokesh on 21/07/23.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
