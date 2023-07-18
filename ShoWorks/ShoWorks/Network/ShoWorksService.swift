//
//  ShoWorksService.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import Foundation
import Combine

protocol ShoWorksService {
    var apiService: ShoWorksAPIService {get}
    
    func authenticateWithSerialNumber(aSerialNumberString: String) -> AnyPublisher<ShoWorksAuthenticationAPIResponse, ShoWorksAPIError>
}

extension ShoWorksService {
    
    func authenticateWithSerialNumber(aSerialNumberString: String) -> AnyPublisher<ShoWorksAuthenticationAPIResponse, ShoWorksAPIError> {
        return apiService.authenticateUser(aSerialNumber: aSerialNumberString, with: ShoWorksEndpoint.authenticateUser)
            .eraseToAnyPublisher()
    }
}
