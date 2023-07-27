//
//  PlistManager.swift
//  ShoWorks
//
//  Created by Lokesh on 26/07/23.
//

import Foundation

class PlistManager {
    
    static let sharedInstance = PlistManager()
    
    
    /// Get Selected Dictionary by filename from sheets detail array
    /// - Parameter selectedFileName: pass a file name
    /// - Returns: returns array of objects
    func getSelectedDicByFileNameFromSheetDetailArray(selectedFileName:String!) -> NSMutableDictionary! {
        
        let sheetDetailArray:NSMutableArray = SharedDelegate.sharedInstance.plistSheetDetailArray!

        for sheetDic in sheetDetailArray {
           
            let sheetObj = sheetDic as! NSDictionary

            if let fileName = sheetObj[AppConstant.sheet_file_name] as? String {
                if (fileName == selectedFileName){
                    return sheetDic as! NSMutableDictionary
                }
            }
         }
        return nil
    }
        
    /// Returns a plist file path from current settings
    /// - Returns: returns a path
    func getPlistFilePathForCurrentSettings() -> String! {

          let serialKey:String! = UserSettings.shared.serialKey?.count ?? 0 > 0 ? UserSettings.shared.serialKey : UserSettings.shared.previousSerialKey

          let channel:String! = UserSettings.shared.selectedChannel

          if !Utilities.sharedInstance.checkStringContainsText(text: serialKey)
              {return ""}

          let applicationDirectoryPath:String! = Utilities.sharedInstance.documentsDirectoryPath().stringByDeletingLastPathComponent
          
          var plistFilePath:String!

          if Utilities.sharedInstance.checkStringContainsText(text: channel)
          {
              plistFilePath = applicationDirectoryPath.stringByAppendingPathComponent(path: String(format:AppConstant.append_cache_path_with_plist_file,String(format:"%@_%@",serialKey,channel)))
          }
          else
          {
              plistFilePath = applicationDirectoryPath.stringByAppendingPathComponent(path: String(format:AppConstant.append_cache_path_with_plist_file,serialKey))
              
          }

          return plistFilePath
      }
    
    /// Method to get Plist data
    /// - Returns: returns an array consists of data from a file
    func getPlistData() -> NSMutableArray! {
          
          let plistPath:String! = self.getPlistFilePathForCurrentSettings()

          var plistArray:NSMutableArray!
          
            do {
                plistArray = NSMutableArray(contentsOfFile: plistPath)
                
            } catch {
                    print("ERROR: ", dump(error, name: "Some error in file"))
            }

            return plistArray

      }
    
    /**    @function    :getPlistDataForDemoMode
     @discussion    :It will return plsit data for demo mode, which is bundled in the app
     @param            :-
     @return        :NSMutableArray : plist data array for sheets
     */
    func getPlistDataForDemoMode() -> NSMutableArray! {

        let plistPath = Bundle.main.path(forResource: AppConstant.plistManagerDemoFileName, ofType: "")

        var plistArray:NSMutableArray!
        
          do {
              plistArray = NSMutableArray(contentsOfFile: plistPath!)
              
          } catch {
                  print("ERROR: ", dump(error, name: "Some error in file"))
          }

        return plistArray
    }
    
    
    /// Fetching data of sheet in a file
    /// - Returns: returns an array consists of data from a file
    func fetchDataOfSheetInFileName(fileName:String!) -> [String:AnyObject]!  {
        let plistArray:[[String:AnyObject]]! = self.getPlistData() as? [[String : AnyObject]]
        
        for sheetDic in plistArray {
            
            if let fileName = sheetDic[AppConstant.sheet_file_name] as? String {
                if (fileName == fileName){
                    return sheetDic
                }
            }
        }

        return nil
    }
    
    
    /// Fetch dictionaires..
    /// - Returns: returns an array consists of data of dictionaries
    func getSheetCellDictionaries() -> NSMutableArray {

        let sheetsArray:NSMutableArray! = NSMutableArray()

        let plistArray:NSMutableArray! = self.getPlistData()
        
        for sheet in plistArray {
            
            let sheetObj = sheet as! NSDictionary

            let obj_sheet = sheetObj.value(forKey: AppConstant.sheet) as! NSDictionary
            
            let name:String! = obj_sheet.value(forKey: AppConstant.sheet_name) as? String
            
            let fileName:String! = sheetObj.value(forKey: AppConstant.sheet_file_name) as? String

            let updated:String! = obj_sheet.value(forKey: AppConstant.sheet_updated) as? String

            let created:String! = obj_sheet.value(forKey: AppConstant.sheet_created) as? String

            let allowDivisionChange:Bool = obj_sheet.value(forKey: AppConstant.sheet_allow_division_change) as! Bool

            let allowClassChange:Bool = obj_sheet.value(forKey: AppConstant.sheet_allow_class_change) as! Bool
            
            var dict = NSMutableDictionary()
            
            dict.setValue(name, forKey: AppConstant.sheet_name)
            dict.setValue(fileName, forKey: AppConstant.sheet_file_name)
            dict.setValue(updated, forKey: AppConstant.sheet_updated)
            dict.setValue(created, forKey: AppConstant.sheet_created)
            dict.setValue(allowDivisionChange, forKey: AppConstant.sheet_allow_division_change)
            dict.setValue(allowClassChange, forKey: AppConstant.sheet_allow_class_change)
            
            sheetsArray.add(dict)
         }
        return sheetsArray
    }
    
    /// Fetch dictionaires..
    /// - Returns: returns an array consists of data of dictionaries
    func getSheetDictionariesFromPlistData(plistData:NSMutableArray!) -> NSMutableArray! {
        let sheetsArray:NSMutableArray! = NSMutableArray()

        for sheet in plistData {
          
            let sheetObj = sheet as! NSDictionary
            let obj_sheet = sheetObj.value(forKey: AppConstant.sheet) as! NSDictionary
            
            let name:String! = obj_sheet.value(forKey: AppConstant.sheet_name) as? String
            
            let fileName:String! = sheetObj.value(forKey: AppConstant.sheet_file_name) as? String

            var updated:String! = obj_sheet.value(forKey: AppConstant.sheet_updated) as? String

            let created:String! = obj_sheet.value(forKey: AppConstant.sheet_created) as? String
            
            if updated == nil || updated.isEmpty {
                updated = created
            }

            let allowDivisionChange:Bool = obj_sheet.value(forKey: AppConstant.sheet_allow_division_change) as! Bool

            let allowClassChange:Bool = obj_sheet.value(forKey: AppConstant.sheet_allow_class_change) as! Bool
            
            
            var dict = NSMutableDictionary()
            
            dict.setValue(name, forKey: AppConstant.sheet_name)
            dict.setValue(fileName, forKey: AppConstant.sheet_file_name)
            dict.setValue(updated, forKey: AppConstant.sheet_updated)
            dict.setValue(created, forKey: AppConstant.sheet_created)
            dict.setValue(allowDivisionChange, forKey: AppConstant.sheet_allow_division_change)
            dict.setValue(allowClassChange, forKey: AppConstant.sheet_allow_class_change)
            
            sheetsArray.add(dict)

         }
        return sheetsArray
    }
    
    
    func removePreviousSheet() -> Bool {
        let path:String! = self.getPlistFilePathForCurrentSettings()

        if path == nil || path.count == 0 {
            return false
        }
        
        if FileManager.default.fileExists(atPath: path){
            try! FileManager.default.removeItem(atPath: path)
            return true
        }

        return false
    }
    
    
    func saveSheetDetailPlist() -> Bool {
        
        let pListArray: NSMutableArray = SharedDelegate.sharedInstance.plistSheetDetailArray as! NSMutableArray

        let isSaved:Bool = pListArray.write(toFile: self.getPlistFilePathForCurrentSettings(), atomically:true)

        return isSaved
    }
    
    func getIndexOfObject(sheetDic:NSDictionary!) -> Int {
        
        if sheetDic == nil {
            return 213213
        }
        
        let pListArray: NSMutableArray = SharedDelegate.sharedInstance.plistSheetDetailArray as! NSMutableArray

        let aFileName: String = sheetDic.value(forKey: AppConstant.sheet_file_name) as! String

        for sheetObject in pListArray {

            let sheetObj = sheetObject as! NSDictionary
            
            let bFileName: String = sheetObj.value(forKey: AppConstant.sheet_file_name) as! String

            if aFileName == bFileName
            {
                return pListArray.index(of: sheetObject)
            }
         }

        return 213213
    }
    
    // Pending coding related to archiving feature
    
//    +(NSString *)getPlistFilePathForArchivedSheet
//    {
//        NSString *serialKey = [SettingsManager getserialKey];
//        NSString *channel = [SettingsManager getSelectedChannel];
//        
//        if(![Utility checkStringContainsText:serialKey])
//            return @"";
//        
//        NSString *applicationDirectoryPath = [[Utility documentsDirectoryPath] stringByDeletingLastPathComponent];
//        NSString *plistFilePath;
//        
//        if([Utility checkStringContainsText:channel])
//        {
//            plistFilePath = [applicationDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:APPEND_CACHE_PATH_WITH_ARCHIVED_PLIST_FILE,[NSString stringWithFormat:@"%@_%@",serialKey,channel]]];
//        }
//        else
//        {
//            plistFilePath = [applicationDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:APPEND_CACHE_PATH_WITH_ARCHIVED_PLIST_FILE,serialKey]];
//        }
//        
//        if(![[NSFileManager defaultManager] fileExistsAtPath:plistFilePath])
//            [[NSFileManager defaultManager] createFileAtPath:plistFilePath contents:nil attributes:nil];
//        
//        return plistFilePath;
//    }
//
//    +(BOOL)saveArchivedPlist
//    {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//        BOOL isSaved = [[appDelegate archivedSheetArray] writeToFile:[self getPlistFilePathForArchivedSheet] atomically:YES];
//        
//        return isSaved;
//    }
//
//    +(NSMutableArray *)getArchivedData
//    {
//        NSString *plistPath = [self getPlistFilePathForArchivedSheet];
//        
//        NSMutableArray *plistArray = nil;
//        
//        @try
//        {
//            plistArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//        }
//        @catch (NSException *exception)
//        {
//            
//        }
//        
//        return plistArray;
//    }
//    
//    +(NSArray *)getSheetCellDictionariesForArchivedData {
//        
//        NSMutableArray *sheetsArray = [[NSMutableArray alloc]init];
//        
//        NSMutableArray *plistArray = [self getArchivedData];
//        
//        for (NSDictionary *sheet in plistArray)
//        {
//            NSString *name = [[sheet objectForKey:SHEET] objectForKey:SHEET_NAME];
//            NSString *fileName = [sheet objectForKey:SHEET_FILE_NAME];
//            
//            NSString *updated = [[sheet objectForKey:SHEET] objectForKey:@"Updated"];
//            //        NSString *entries = [[sheet objectForKey:SHEET] objectForKey:@"Entries"];
//            NSString *created = [[sheet objectForKey:SHEET] objectForKey:@"Created"];
//            
//            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:name, SHEET_NAME, fileName, SHEET_FILE_NAME, updated, SHEET_UPDATED, created, SHEET_CREATED, nil];
//            
//            [sheetsArray addObject:dict];
//        }
//        
//        return sheetsArray;
//    }

}
