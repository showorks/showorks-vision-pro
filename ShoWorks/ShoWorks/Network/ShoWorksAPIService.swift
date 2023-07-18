//
//  ShoWorksAPIService.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import Foundation
import Combine

protocol ShoWorksAPIService{
    func authenticateUser<T: Decodable>(aSerialNumber: String,with builder: RequestBuilder) -> AnyPublisher<T, ShoWorksAPIError>
}

protocol RequestBuilder {
    func authenticateUserRequest(aSerialNumber: String) -> URLRequest
}

enum ShoWorksAPIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}
