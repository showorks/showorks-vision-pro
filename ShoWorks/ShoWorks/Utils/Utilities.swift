//
//  Utilities.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation
import SwiftUI

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
        
        if let cacheDirectoryPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
            return cacheDirectoryPath
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
    
    
    
    func isNetworkStatusAvailable() -> Bool {
        let reachability:Reachability! = Reachability.forInternetConnection()
        let internetStatus:NetworkStatus = reachability.currentReachabilityStatus()
        if internetStatus != NotReachable {
            return true
        }
        return false
    }
    
    func getTimeAccordingToDateOrMinutesAgoAccordingly(time:String!) -> String! {
        
        if !Utilities.sharedInstance.checkStringContainsText(text: time)
        
        {return "-"}

        let today:Date! = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"

        let timeDate:Date! = dateFormatter.date(from: time)

        dateFormatter.dateFormat = "MM/dd/yyyy"

        let timeDateOnly:String! = dateFormatter.string(from: timeDate)

        let todayDateOnly:String! = dateFormatter.string(from: today)

          if (todayDateOnly == timeDateOnly)
          {
              let calender = Calendar(identifier: .gregorian)
              let units: Set<Calendar.Component> = [.minute]
              let components = calender.dateComponents(units, from: timeDate, to: today)
              
              if components.minute!<=1 {
                  return "just now"
              }
              else if components.minute! < 60
              {
                  return String(format:"%i minutes ago",components.minute!)
              }
              else
              {
                  dateFormatter.dateFormat = "h:mm a"
                  let timetimeOnly:String! = dateFormatter.string(from: timeDate)
                  return String(format:"today at %@",timetimeOnly)
              }
          }
          else
          {
              dateFormatter.dateFormat = "EEE d MMM"
              var atime = dateFormatter.string(from: timeDate)
              dateFormatter.dateFormat = "h:mm a"
              let onlyTimeWithAMPM:String! = dateFormatter.string(from: timeDate)
              return String(format:"on %@ at %@",atime,onlyTimeWithAMPM)
          }
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


// Extension for notification publisher
extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(
            center.publisher(for: name, object: object),
            perform: action
        )
    }
}
