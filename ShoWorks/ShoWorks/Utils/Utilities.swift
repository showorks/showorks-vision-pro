//
//  Utilities.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation

class Utilities {
    
    static let sharedInstance = Utilities()
    
    func createFolderInDocumentDirectoryWithPath(folderPath:String!) {
    
        if FileManager.default.fileExists(atPath: folderPath) == false{
           do {
               try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: .none)
           } catch {
               print(error.localizedDescription)
           }
        }
   }
}
