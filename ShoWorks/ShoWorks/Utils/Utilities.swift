//
//  Utilities.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation

class Utilities {
    
    static let sharedInstance = Utilities()
    
    /// Method related to creation of folder at a path
    /// - Parameter folderPath: path needs to be specified here
    func createFolderInDocumentDirectoryWithPath(folderPath:String!) {
    
        if FileManager.default.fileExists(atPath: folderPath) == false{
           do {
               try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: false, attributes: .none)
           } catch {
               print(error.localizedDescription)
           }
        }
        print(folderPath)
   }
    
    func isDataPresentForCurrentSerialNumber() -> Bool {
        var dataPath:String! = PlistManager.sharedInstance.getPlistFilePathForCurrentSettings()

        dataPath = dataPath.stringByDeletingLastPathComponent

        return FileManager.default.fileExists(atPath: dataPath)
    }
    
    /// get Documents directory path
    /// - Returns: return document directory path
    func documentsDirectoryPath() -> String! {
        
        if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            return documentsDirectoryPath
        }
        
        return ""
    }
    
    /// get Cache Directory Path
    /// - Returns: cache directory path
    func cacheDirectoryPath() -> String! {
        
        if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            return documentsDirectoryPath
        }
        
        return ""
    }
    
    /// Check if string has a text or not
    /// - Returns: returns true/false
    func checkStringContainsText(text:String!) -> Bool {
        if let textOfString = text, textOfString.count > 0 {
            return true
        }
        return false
    }
    
    
}



/// Extension of String to convert from NSString and use some of the common methods, variables we used to use in Objective-C

extension String {
  
    var lastPathComponent: String {
         
        get {
            return (self as NSString).lastPathComponent
        }
    }
    var pathExtension: String {
         
        get {
             
            return (self as NSString).pathExtension
        }
    }
    var stringByDeletingLastPathComponent: String {
         
        get {
             
            return (self as NSString).deletingLastPathComponent
        }
    }
    var stringByDeletingPathExtension: String {
         
        get {
             
            return (self as NSString).deletingPathExtension
        }
    }
    var pathComponents: [String] {
         
        get {
             
            return (self as NSString).pathComponents
        }
    }
  
    func stringByAppendingPathComponent(path: String) -> String {
         
        let nsSt = self as NSString
         
        return nsSt.appendingPathComponent(path)
    }
  
    func stringByAppendingPathExtension(ext: String) -> String? {
         
        let nsSt = self as NSString
         
        return nsSt.appendingPathExtension(ext)
    }
    
    func replace(target: String, withString: String) -> String
    {
       return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func lastLetter() -> String {
        guard let lastChar = self.last else {
            return ""
        }
        return String(lastChar)
    }
}
