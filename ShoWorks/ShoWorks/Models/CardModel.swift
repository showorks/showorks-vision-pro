//
//  CardModel.swift
//  ShoWorks
//
//  Created by Lokesh on 27/09/23.
//

import Foundation

struct CardModel: Identifiable {
    let id = UUID()
    let departmentName: String
    let exhibitorName: String
    let entryNumber: Int
    let wenNumber: String
    
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
    
    static var data: [CardModel] {
        [
        CardModel(name: "Jon", imageName: "SplashLogo", age: 2, bio: "Married to Caitlin, fast kids"),
        CardModel(name: "Eliud", imageName: "SplashLogo", age: 31, bio: "Marathon GOAT WR Holder"),
        CardModel(name: "Jackson", imageName:"SplashLogo", age: 19, bio: "UChicago's Hottest Frosh (Hoobyjogger)"),
        CardModel(name: "Kevin", imageName:"SplashLogo", age: 23, bio: "Taylor Swift's #1 Fan"),
        CardModel(name: "Taylor", imageName:"SplashLogo", age: 32, bio: "Artist of the Century"),
        CardModel(name: "Monica", imageName:"SplashLogo", age: 1, bio: "3.97 GPA and faster than K Sun")
        
        ]
    }
}
