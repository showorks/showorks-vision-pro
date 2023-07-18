//
//  ShoWorksEndpoint.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import Foundation

enum ShoWorksEndpoint {
    case authenticateUser
}

extension ShoWorksEndpoint : RequestBuilder {
    
    func authenticateUserRequest(aSerialNumber: String) -> URLRequest{
        guard let url = URL(string: String.init(format: "%@%@?%@=%@", APIConstants.baseURL,APIConstants.authenticateUser,APIConstants.requestParameterSVAL,aSerialNumber)) else {
                preconditionFailure("Invalid URL")
            }
            let request = URLRequest(url: url)
            return request
    }
}
