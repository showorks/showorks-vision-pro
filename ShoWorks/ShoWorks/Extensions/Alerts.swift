//
//  Alerts.swift
//  ShoWorks
//
//  Created by Lokesh on 17/07/23.
//

import Foundation


enum AlertType {
    case error(underlyingError: Error)
    case feedback(message: String, action: (() -> Void)?)
    case actionable(title: String,
                    message: String,
                    destructiveText: String,
                    destructiveAction: (() -> Void),
                    dismissText: String,
                    dismissAction:(() -> Void))
    case dismiss(title: String,
                    message: String,
                    dismissText: String,
                    dismissAction:(() -> Void))
}


struct AlertItem: Identifiable {
    let id = UUID()
    let type: AlertType
}

import SwiftUI
extension AlertItem {
    func asAlert() -> Alert {
        type.asAlert()
    }
}

extension AlertType {
    
    func asAlert() -> Alert {
        switch self {
        case .error(let underlyingError):
            return Alert(title: Text("Error".localized()),
                         message: Text("An error occured \(underlyingError.localizedDescription)"),
                         dismissButton: .default(Text("dismiss".localized())))
        case .feedback(let message,
                       let action):
            return Alert(title: Text(""),
                         message: Text(message),
                         dismissButton: .default(Text("dismiss".localized()), action: action))
        case .actionable(let title,
                         let message,
                         let destructiveText,
                         let destructiveAction,
                         let dismissText,
                         let dismissAction):
            return Alert(title: Text(title),
                         message: Text(message),
                         primaryButton: .destructive(Text(destructiveText), action: destructiveAction),
                         secondaryButton: .default(Text(dismissText), action: dismissAction))
            
        case .dismiss(let title,
                             let message,
                             let dismissText,
                             let dismissAction):
                return Alert(title: Text(title),
                             message: Text(message),
                             dismissButton: .default(Text(dismissText), action: dismissAction))
                
                
            }
        }
}
