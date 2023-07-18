//
//  ShoWorksAuthenticationModel.swift
//  ShoWorks
//
//  Created by Lokesh on 18/07/23.
//

import SwiftUI
import Combine
import Foundation

class ShoWorksAuthenticationModel: ObservableObject, ShoWorksService {
    var apiService: ShoWorksAPIService
    @Published var isLoading :  Bool
    @Published var authenticationResponse :  ShoWorksAuthenticationAPIResponse?
    
    var cancellables = Set<AnyCancellable>()
    
    init(apiSession: ShoWorksAPIService = ShoWorksAPISession()) {
        authenticationResponse = nil
        self.apiService = apiSession
        self.isLoading = false
    }
    
    func authenticateWithSerialNumber(serialNumber: String) {
        self.isLoading = true
        let cancellable = self.authenticateWithSerialNumber(aSerialNumberString: serialNumber)
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
                self.isLoading = false
            }) { (response) in
                self.isLoading = false
                self.authenticationResponse = response
                
                if let authenticationResponseObj = self.authenticationResponse {
                    var accessKey = authenticationResponseObj.AKID
                    var secretKey = authenticationResponseObj.SAK
                        
                    UserSettings.shared.accessKey = accessKey
                    UserSettings.shared.secretKey = secretKey
                    UserSettings.shared.serialKey = serialNumber
                    
                }
        }
        cancellables.insert(cancellable)
    }
}
