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
    let clubName: String
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0
    var degree: Double = 0.0
    
    static var data: [CardModel] {
        [
            CardModel(departmentName: "Photography", exhibitorName: "Jon", entryNumber: 372, wenNumber: "73D8FE", clubName: "Pass Pioneers"),
            CardModel(departmentName: "Horses", exhibitorName: "Eliud", entryNumber: 387, wenNumber: "93D8FE", clubName: "Pass Pioneers"),
            CardModel(departmentName: "Beef", exhibitorName: "Jackson", entryNumber: 387, wenNumber: "NAD8FE", clubName: "Pass Pioneers")
        ]
    }
}
