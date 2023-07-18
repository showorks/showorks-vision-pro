//
//  ShoWorksAuthenticationAPIResponse.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import Foundation

// Model used to pull markets
struct ShoWorksAuthenticationAPIResponse: Codable, Equatable {
   
    var STATUS: String
    var AKID : String
    var SAK : String
    var FN : String
    var LASER : String
    
    enum CodingKeys: CodingKey {
        case STATUS
        case AKID
        case SAK
        case FN
        case LASER
    }
}
