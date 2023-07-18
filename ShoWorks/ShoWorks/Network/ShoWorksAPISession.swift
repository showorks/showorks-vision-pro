//
//  ShoWorksAPISession.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import Foundation
import Combine

struct ShoWorksAPISession: ShoWorksAPIService {
    
    func authenticateUser<T>(aSerialNumber: String,with builder: RequestBuilder) -> AnyPublisher<T, ShoWorksAPIError> where T: Decodable {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return URLSession.shared
            .dataTaskPublisher(for: builder.authenticateUserRequest(aSerialNumber: aSerialNumber))
            .receive(on: DispatchQueue.main)
            .mapError { _ in .unknown }
            .flatMap { data, response -> AnyPublisher<T, ShoWorksAPIError> in
                if let response = response as? HTTPURLResponse {
                    if (200...299).contains(response.statusCode) {
                    return Just(data)
                        .decode(type: T.self, decoder: decoder)
                        .mapError {_ in .decodingError}
                        .eraseToAnyPublisher()
                    } else {
                        return Fail(error: ShoWorksAPIError.httpError(response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: ShoWorksAPIError.unknown)
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
