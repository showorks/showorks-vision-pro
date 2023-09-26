//
//  SearchingUtility.m
//  iPadApp
//
//  Created by LeewayHertz on 24/04/13.
//
//

#import "SearchingUtility.h"
#import "SearchDataModel.h"
#import "QRScannedModel.h"

#define DEPARTMENT_NAME @"name"
#define DEPARTMENT_ATTRIBUTES @"Attributes"

#define CLASS_ATTRIBUTES @"Attributes"
#define CLASS_ENTRIES @"Entries"
#define SHEET_DEPARTMENTS @"Departments"
#define SHEET_CLASSES @"Classes"
#define SHEET_DIVISIONS @"Divisions"
#define SHEET_PASSWORD @"Password"
#define SHEET_CREATED @"Created"
#define SHEET_NAME @"Name"
#define SHEET_UPDATED @"Updated"
#define ENTRY_UPDATED @"updated"
#define SHEET_ENTRIES @"Entries"
#define SHEET_FILE_NAME @"Filename"
#define SHEET_ATTRIBUTES @"Attributes"
#define SHEET_TEMPLATE @"Template"

#define DIVISION_ATTRIBUTES @"Attributes"
#define CLASS_NAME @"name"
#define DIVISION_NAME @"name"
#define ENTRY_ID @"ID"
#define ENTRY_COLUMNS @"Columns"
#define ENTRY_ATTRIBUTES @"Attributes"
#define ENTRY_MOVED @"Moved"
#define TRUE_KEY @"True"
#define SHEET_HEADING_EXHIBITOR @"Exhibitor"
#define SHEET_HEADING_EXHIBITOR_CAPITAL @"EXHIBITOR"
#define SHEET_HEADING_ENTRY @"Entry#"
#define SHEET_HEADING_CLUB @"Club"
#define SHEET_HEADING_CLUB_CAPITAL @"CLUB"
#define SHEET_HEADING_CHECKMARK @"Icon"
#define SHEET_HEADING_DESCRIPTION @"Description"
#define SHEET_HEADING_TAG @"Tag"

#define SHEET_HEADING_AGE @"Age"
#define SHEET_HEADING_CITY @"City"
#define SHEET_HEADING_STATE @"State"
#define SHEET_HEADING_EXHIBITORID @"ExhibitorID"
#define DEPARTMENT @"Department"
#define CLASS @"Class"
#define DIVISION @"Division"
#define WEN_KEY @"WEN"
#define RFIDReaderPopoverKeyEID @"EID"
#define LAST_UPDATED_DATE @"LastUpdatedDate"
#define QRCodeScannerPopoverQuickConfirmModeUpdated @"updated"
#define SHEET_HEADER_HEADING @"heading"

/**Format of sheets plist
 
 (
    Sheet0{
             Departments : (    {
                                    Attributes  : { name : -- };
                                    Divisions   : (     {
                                                            Attributes  : { name : -- };
                                                            Classes     : (
                                                                              {
                                                                                  Attributes  : { name : -- };
                                                                                  Entries     : (
                                                                                                    {
                                                                                                     Attributes  : { ID : -- };
                                                                           Columns     :  (
                                                                                              Item0 : --,
                                                                                              Item1 : --,
                                                                                              ...,...,
                                                                                              ItemN
                                                                                          );
                                                                                                    },
                                                                                                    ...,...,...
                                                                                                    {}
                                                                                                );
                                                                              },
                                                                              ...,...,...,
                                                                              {}
                                                                          );
                                                        },
                                                        ...,...,...,
                                                        {}
                                                  );
                                },
                                ....,....,...,
                                {}
                           );
             Filename    :  nameOfTheSheet;
             Sheet       : {                                // Sheet meta data
                               Created  :   --
                               Entries  :   --
                               Fair     :   --
                               Name     :   --
                               Password :   --
                               Serial   :   --
                               Updated  :   --
                           };
             Template    : (                                // Template of columns
                               {
                                   align    :   --
                                   font     :   --
                                   heading  :   --
                                   type     :   --
                                   width    :   --
                               },
                               ,...,....,...
                               ,{}
                           );
          }
    ,....
    ,....
    ,....
    ,SheetN
 )
 
 */

@implementation SearchingUtility


+(BOOL) checkStringContainsText:(NSString *)text
{
    if( [text isKindOfClass:[NSString class]] && [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0 )
        return TRUE;
    return FALSE;
}

+(void)getSearchModelsFromSearchText:(NSString *)searchText inSheetDic:(NSMutableDictionary *)sheetDic inSearchModelArray:(NSMutableArray *)searchModelArray
{
    if(![self checkStringContainsText:searchText] || !sheetDic || !searchModelArray)
        return;
    
    NSArray *departmentsArray = [sheetDic objectForKey:SHEET_DEPARTMENTS];
    
    [self searchText:searchText andGetSearchModelsInArray:searchModelArray fromDepartmentsArray:departmentsArray];
}

+(void)searchText:(NSString *)searchText andGetSearchModelsInArray:(NSMutableArray *)searchModelArray fromDepartmentsArray:(NSArray *)departmentsArray
{
    if(!departmentsArray || !searchModelArray)
        return;
    
    for (NSDictionary *departmentDic in departmentsArray)
    {
        NSString *departmentName = [[departmentDic objectForKey:DEPARTMENT_ATTRIBUTES] objectForKey:DEPARTMENT_NAME];
        NSString *divisionName;
        NSString *className;
        NSArray *divisionsArray = [departmentDic objectForKey:SHEET_DIVISIONS];
        for (NSDictionary *divisionDic in divisionsArray)
        {
            divisionName = [[divisionDic objectForKey:DIVISION_ATTRIBUTES] objectForKey:DIVISION_NAME];
            NSArray *classesArray = [divisionDic objectForKey:SHEET_CLASSES];
            for (NSDictionary *classDic in classesArray)
            {
                className = [[classDic objectForKey:CLASS_ATTRIBUTES] objectForKey:CLASS_NAME];
                NSArray *entriesArray = [classDic objectForKey:SHEET_ENTRIES];
                for (NSDictionary *entryDic in entriesArray)
                {
                    NSString *entryId = [[entryDic objectForKey:CLASS_ATTRIBUTES] objectForKey:ENTRY_ID];
                    NSArray *columnsArray = [entryDic objectForKey:ENTRY_COLUMNS];
                    
//                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@", searchText];
//                    NSArray *results = [columnsArray filteredArrayUsingPredicate:predicate];
//                    if (!results||results.count==0) {
//                        continue;
//                    }
                    if(![self isSearchText:searchText existsInArray:columnsArray])
                        continue;
                    
                    [self createAndAddSearchDataModelInArray:searchModelArray withDepartmentName:departmentName divisionName:divisionName className:className classDetailDic:classDic withSearchedEntryId:entryId];
                }
            }
        }
        
    }
}
+(NSMutableArray *)searchManualEntry:(NSString *)searchText inSheetDic:(NSMutableDictionary *)sheetDic
{
    if(![self checkStringContainsText:searchText] || !sheetDic )
        return nil;
    
    NSArray *departmentsArray = [sheetDic objectForKey:SHEET_DEPARTMENTS];
    NSMutableArray *searchData=[NSMutableArray new];
    [self searchExhibitorAndClubName:searchText andGetSearchModelsInArray:searchData fromDepartmentsArray:departmentsArray withIndexOfClub:[self getIndexValueOfClubFromSheetDic:sheetDic]];
    return searchData;
}
+(void)searchExhibitorAndClubName:(NSString *)searchText andGetSearchModelsInArray:(NSMutableArray *)searchModelArray  fromDepartmentsArray:(NSArray *)departmentsArray withIndexOfClub:(int)clubIndex
{
    if(!departmentsArray || !searchModelArray)
        return;
    
    for (NSDictionary *departmentDic in departmentsArray)
    {
        NSString *departmentName = [[departmentDic objectForKey:DEPARTMENT_ATTRIBUTES] objectForKey:DEPARTMENT_NAME];
        NSString *divisionName;
        NSString *className;
        NSArray *divisionsArray = [departmentDic objectForKey:SHEET_DIVISIONS];
        for (NSDictionary *divisionDic in divisionsArray)
        {
            divisionName = [[divisionDic objectForKey:DIVISION_ATTRIBUTES] objectForKey:DIVISION_NAME];
            NSArray *classesArray = [divisionDic objectForKey:SHEET_CLASSES];
            for (NSDictionary *classDic in classesArray)
            {
                className = [[classDic objectForKey:CLASS_ATTRIBUTES] objectForKey:CLASS_NAME];
                NSArray *entriesArray = [classDic objectForKey:SHEET_ENTRIES];
                for (NSDictionary *entryDic in entriesArray)
                {
                    NSString *exhibitor = [[entryDic objectForKey:CLASS_ATTRIBUTES] objectForKey:SHEET_HEADING_EXHIBITOR];
                    NSString *clubName = nil;
                    if(clubIndex!=-1){
                        clubName  = [[entryDic objectForKey:ENTRY_COLUMNS] objectAtIndex:clubIndex];
                    }
                    // If it contains and exhibitor or club then only perform search
                    if([self isSearchText:searchText matchedWith:exhibitor] || [self isSearchText:searchText matchedWith:clubName]){
                        NSString *entryId = [[entryDic objectForKey:CLASS_ATTRIBUTES] objectForKey:ENTRY_ID];
                        [self createAndAddSearchDataModelForExhibitor:searchModelArray withDepartmentName:departmentName divisionName:divisionName className:className classDetailDic:classDic withSearchedEntryId:entryId];
                    }
                }
            }
        }
    }
}

/**	@function	:isSearchText: existsInArray:
 @discussion	:Method checks for the search text in columns and return a bool
 @param	        :searchText - containsSearchingText, columnsArray - containsColumnsData
 @result	    :Bool - is searching text exists in column array or not.
 */

+(BOOL)isSearchText:(NSString *)searchText existsInArray:(NSArray *)columnsArray
{
    if(![self checkStringContainsText:searchText] || !columnsArray)
        return FALSE;
    
//    NSString *firstChar = [searchText substringToIndex:1];
//    
//    NSString *lastChar = [searchText substringFromIndex:[searchText length] - 1];
//    
//    searchText = [searchText stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
//    if([firstChar isEqualToString:@"*"] && [lastChar isEqualToString:@"*"])
//    {
        for (NSString *columnText in columnsArray)
        {
            NSRange range = [columnText rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(range.location != NSNotFound)
                return TRUE;
        }
//    }
//    else if([firstChar isEqualToString:@"*"])
//    {
//        for (NSString *columnText in columnsArray)
//        {
//            NSRange suffixRange = [columnText rangeOfString:searchText
//                                                  options:(NSAnchoredSearch | NSCaseInsensitiveSearch | NSBackwardsSearch)];
//            
//            if(suffixRange.location != NSNotFound)
//                return TRUE;
//        }
//    }
//    else if([lastChar isEqualToString:@"*"])
//    {
//        for (NSString *columnText in columnsArray)
//        {
//            NSRange prefixRange = [columnText rangeOfString:searchText
//                                                    options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
//            
//            if(prefixRange.location != NSNotFound)
//                return TRUE;
//        }
//    }
//    else
//    {
//        for (NSString *columnText in columnsArray)
//        {
//            if([columnText isEqualToString:searchText])
//                return TRUE;
//        }
//    }

    return FALSE;
}
+(BOOL)isSearchText:(NSString *)searchText matchedWith:(NSString *)text
{
    if(![self checkStringContainsText:searchText] || !text)
        return FALSE;
    
    NSString *firstChar = [searchText substringToIndex:1];
    
    NSString *lastChar = [searchText substringFromIndex:[searchText length] - 1];
    
    searchText = [searchText stringByReplacingOccurrencesOfString:@"*" withString:@""];
    
    if([firstChar isEqualToString:@"*"] && [lastChar isEqualToString:@"*"])
    {
//        for (NSString *columnText in columnsArray)
//        {
            NSRange range = [text rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if(range.location != NSNotFound)
                return TRUE;
//        }
    }
    else if([firstChar isEqualToString:@"*"])
    {
//        for (NSString *columnText in columnsArray)
//        {
            NSRange suffixRange = [text rangeOfString:searchText
                                                    options:(NSAnchoredSearch | NSCaseInsensitiveSearch | NSBackwardsSearch)];
            
            if(suffixRange.location != NSNotFound)
                return TRUE;
//        }
    }
    else if([lastChar isEqualToString:@"*"])
    {
//        for (NSString *columnText in columnsArray)
//        {
            NSRange prefixRange = [text rangeOfString:searchText
                                                    options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
            
            if(prefixRange.location != NSNotFound)
                return TRUE;
//        }
    }
    else
    {
//        for (NSString *columnText in columnsArray)
//        {
            if([[text lowercaseString] isEqualToString:[searchText lowercaseString]])
                return TRUE;
//        }
    }
    return FALSE;
}
+(void)createAndAddSearchDataModelForExhibitor:(NSMutableArray *)searchModelArray withDepartmentName:(NSString *)departmentName divisionName:(NSString *)divisionName className:(NSString *)className classDetailDic:(NSDictionary *)classDic withSearchedEntryId:(NSString *)entryId
{
    if(!searchModelArray || ![self checkStringContainsText:departmentName] || ![self checkStringContainsText:divisionName] || ![self checkStringContainsText:className] || ![self checkStringContainsText:entryId] || !classDic)
        return;
    SearchDataModel *searchDataObj =nil;
    NSMutableArray *searchedEntryIdArray;
    searchDataObj = [[SearchDataModel alloc] init];
    
    [searchDataObj setDepartmentName:departmentName];
    [searchDataObj setDivisionName:divisionName];
    [searchDataObj setClassName:className];
    [searchDataObj setClassDetailDic:classDic];
    
    searchedEntryIdArray = [[NSMutableArray alloc] init];
    [searchDataObj setSearchedEntryIdArray:searchedEntryIdArray];
//    [searchedEntryIdArray release],searchedEntryIdArray = nil;
    
    [searchModelArray addObject:searchDataObj];
    
    searchedEntryIdArray = [searchDataObj searchedEntryIdArray];
    
//    [searchDataObj release],searchDataObj = nil;
    
    
    if(![searchedEntryIdArray containsObject:entryId])
        [searchedEntryIdArray addObject:entryId];
    
    
}
+(void)createAndAddSearchDataModelInArray:(NSMutableArray *)searchModelArray withDepartmentName:(NSString *)departmentName divisionName:(NSString *)divisionName className:(NSString *)className classDetailDic:(NSDictionary *)classDic withSearchedEntryId:(NSString *)entryId
{
    if(!searchModelArray || ![self checkStringContainsText:departmentName] || ![self checkStringContainsText:divisionName] || ![self checkStringContainsText:className] || ![self checkStringContainsText:entryId] || !classDic)
        return;
    
    SearchDataModel *searchDataObj = [self getSearchDataObjIfAlreadyExistInArray:searchModelArray withClassName:className departmentName:departmentName divisionName:divisionName];
    NSMutableArray *searchedEntryIdArray;
    
    if(!searchDataObj)
    {
        searchDataObj = [[SearchDataModel alloc] init];
        
        [searchDataObj setDepartmentName:departmentName];
        [searchDataObj setDivisionName:divisionName];
        [searchDataObj setClassName:className];
        [searchDataObj setClassDetailDic:classDic];
        
        searchedEntryIdArray = [[NSMutableArray alloc] init];
        [searchDataObj setSearchedEntryIdArray:searchedEntryIdArray];
//        [searchedEntryIdArray release],searchedEntryIdArray = nil;
        
        [searchModelArray addObject:searchDataObj];
        
        searchedEntryIdArray = [searchDataObj searchedEntryIdArray];
        
//        [searchDataObj release],searchDataObj = nil;
    }
    else
    {
        searchedEntryIdArray = [searchDataObj searchedEntryIdArray];
    }

    if(![searchedEntryIdArray containsObject:entryId])
        [searchedEntryIdArray addObject:entryId];
}

+(SearchDataModel *)getSearchDataObjIfAlreadyExistInArray:(NSMutableArray *)searchModelArray withClassName:(NSString *)className departmentName:(NSString *)departmentName divisionName:(NSString *)divisionName
{
    if(!searchModelArray || ![self checkStringContainsText:departmentName] || ![self checkStringContainsText:divisionName] || ![self checkStringContainsText:className])
        return nil;
    
    for (SearchDataModel *searchDataObj in searchModelArray)
    {
        NSString *searchedClassName = [searchDataObj className];
        NSString *searchedDepartmentName = [searchDataObj departmentName];
        NSString *searchedDivisionName = [searchDataObj divisionName];
        
        if([searchedClassName isEqualToString:className] && [searchedDivisionName isEqualToString:divisionName] && [searchedDepartmentName isEqualToString:departmentName])
            return searchDataObj;
    }
    
    return nil;
}



///**	@function	:addUpdateAttributeInSheetDic:withQRScanModel:
// @discussion	:It will add update attribute in entry column for particular entry id in qrScannedModelObj
// @param	        :sheetDic - SheetData, qrScannedModelObj - contains scanned data
// @return	    :void
// */
//+(void)addUpdateAttributeInSheetDic:(NSDictionary *)sheetDic withQRScanModel:(QRScannedModel *)qrScannedModelObj
//{
//    if(!sheetDic || !qrScannedModelObj)
//        return;
//    
//    
//    NSString *departmentName;
//    NSString *divisionName;
////    NSString *className;
//    NSString *entryId = [qrScannedModelObj entryId];
//    
//    if(![Utility checkStringContainsText:entryId])
//        return;
//    
//    NSArray *departmentsArray = [sheetDic objectForKey:SHEET_DEPARTMENTS];
//    
//    for (NSDictionary *departmentDic in departmentsArray)
//    {
//        departmentName = [[departmentDic objectForKey:DEPARTMENT_ATTRIBUTES] objectForKey:DEPARTMENT_NAME];
////        if(![departmentName isEqualToString:department])
////            continue;
//        NSArray *divisionsArray = [departmentDic objectForKey:SHEET_DIVISIONS];
//        for (NSDictionary *divisionDic in divisionsArray)
//        {
//            divisionName = [[divisionDic objectForKey:DIVISION_ATTRIBUTES] objectForKey:DIVISION_NAME];
////            if(![divisionName isEqualToString:division])
////                continue;
//            NSArray *classesArray = [divisionDic objectForKey:SHEET_CLASSES];
//            for (NSDictionary *classDic in classesArray)
//            {
////                NSString *classNameFromDic = [[classDic objectForKey:CLASS_ATTRIBUTES] objectForKey:CLASS_NAME];
////                if(![classNameFromDic isEqualToString:className])
////                    continue;
//                NSArray *entriesArray = [classDic objectForKey:SHEET_ENTRIES];
//                for (NSMutableDictionary *entryDic in entriesArray)
//                {
//                    NSString *entryIdFromDic = [[entryDic objectForKey:CLASS_ATTRIBUTES] objectForKey:ENTRY_ID];
//                    if(![entryIdFromDic isEqualToString:entryId])
//                        continue;
//                    NSMutableArray *columnsArray = [entryDic objectForKey:ENTRY_COLUMNS];
//                    int checkmarkIndex = [self getIndexValueOfChekmarkFromSheetDic:sheetDic];
//                    if(checkmarkIndex == -1)
//                        return;
//                    
//                    [columnsArray replaceObjectAtIndex:checkmarkIndex withObject:_YES];
//                    [entryDic setObject:@"" forKey:QRCodeScannerPopoverQuickConfirmModeUpdated];
//                    break;
//                }
//            }
//        }
//    }
//}

+(NSMutableDictionary *)getSearchedClassDicForQRScanModel:(QRScannedModel *)qrScannedModelObj fromSheetDic:(NSDictionary *)sheetDic andIsAddUpdatedAttributeInEntryNode:(BOOL)isAddUpdated
{
    if(!sheetDic || !qrScannedModelObj)
        return nil;
    
    NSString *departmentName;
    NSString *divisionName;

    NSString *wenOrEntryId = [qrScannedModelObj wenOrEntryId];
    NSString *entryId;
    
    if(![self checkStringContainsText:wenOrEntryId])
        return nil;
    
    NSArray *departmentsArray = [sheetDic objectForKey:SHEET_DEPARTMENTS];

    
    for (NSDictionary *departmentDic in departmentsArray)
    {
        departmentName = [[departmentDic objectForKey:DEPARTMENT_ATTRIBUTES] objectForKey:DEPARTMENT_NAME];

        NSArray *divisionsArray = [departmentDic objectForKey:SHEET_DIVISIONS];
        for (NSDictionary *divisionDic in divisionsArray)
        {
            divisionName = [[divisionDic objectForKey:DIVISION_ATTRIBUTES] objectForKey:DIVISION_NAME];

            NSArray *classesArray = [divisionDic objectForKey:SHEET_CLASSES];
            for (NSDictionary *classDic in classesArray)
            {
                NSArray *entriesArray = [classDic objectForKey:SHEET_ENTRIES];
                for (NSMutableDictionary *entryDic in entriesArray)
                {
                    NSDictionary *entryAttributeDic = [entryDic objectForKey:CLASS_ATTRIBUTES];
                    if([qrScannedModelObj searchKey] == ENTRYID)
                    {
                        entryId = [entryAttributeDic objectForKey:ENTRY_ID];
                        if(![entryId isEqualToString:wenOrEntryId])
                            continue;
                    }
                    else if([qrScannedModelObj searchKey] == WEN)
                    {
                        if(![[entryAttributeDic allKeys] containsObject:WEN_KEY])
                            continue;
                        
                        entryId = [entryAttributeDic objectForKey:ENTRY_ID];
                        NSString *wenId = [entryAttributeDic objectForKey:WEN_KEY];
                        if(![wenId isEqualToString:wenOrEntryId])
                            continue;
                    }
                    else if([qrScannedModelObj searchKey] == EXHIBITOR)
                    {
                        if(![[entryAttributeDic allKeys] containsObject:WEN_KEY])
                            continue;
                        
                        entryId = [entryAttributeDic objectForKey:ENTRY_ID];
                        NSString *exhibitor = [entryAttributeDic objectForKey:SHEET_HEADING_EXHIBITOR];
                        if(![exhibitor isEqualToString:wenOrEntryId])
                            continue;
                    }
                    else if([qrScannedModelObj searchKey] == EID)
                    {
                        if(![[entryAttributeDic allKeys] containsObject:RFIDReaderPopoverKeyEID])
                            continue;
                        
                        entryId = [entryAttributeDic objectForKey:ENTRY_ID];
                        NSString *EID = [entryAttributeDic objectForKey:RFIDReaderPopoverKeyEID];
                        if(![EID isEqualToString:wenOrEntryId])
                            continue;
                    }

                    
                    if(isAddUpdated)
                    {
//                        int checkmarkIndex = [self getIndexValueOfChekmarkFromSheetDic:sheetDic];
//                        if(checkmarkIndex != -1)
                        [self addUpdatedAttributeAndEnableCheckmarkInEntryDic:entryDic atCheckmarkIndex:0];
                        
                    }
                    
                    NSMutableDictionary *searchedClassDic = [[NSMutableDictionary alloc] init];
                    
                    NSMutableDictionary *searchedClassDetailDic = [[NSMutableDictionary alloc] init];
                    [searchedClassDetailDic setObject:departmentName forKey:DEPARTMENT];
                    [searchedClassDetailDic setObject:divisionName forKey:DIVISION];
                    [searchedClassDetailDic setObject:classDic forKey:CLASS];
                    
                    [searchedClassDic setObject:searchedClassDetailDic forKey:CLASS];

                    [searchedClassDic setObject:entryId forKey:ENTRY_ID];
                    
//                    [searchedClassDetailDic release],searchedClassDetailDic = nil;
                    return searchedClassDic;
                }
            }
        }
    }
    return nil;
}

+(NSMutableDictionary *)getSearchedClassDicForSearchId:(NSString *)searchID fromSheetDic:(NSDictionary *)sheetDic andIsAddUpdatedAttributeInEntryNode:(BOOL)isAddUpdated
{
    if(!sheetDic || !searchID)
        return nil;
    
    NSString *departmentName;
    NSString *divisionName;
    

    NSString *entryId;
    
    if(![self checkStringContainsText:searchID])
        return nil;
    
    NSArray *departmentsArray = [sheetDic objectForKey:SHEET_DEPARTMENTS];
    
    
    for (NSDictionary *departmentDic in departmentsArray)
    {
        departmentName = [[departmentDic objectForKey:DEPARTMENT_ATTRIBUTES] objectForKey:DEPARTMENT_NAME];
        NSArray *divisionsArray = [departmentDic objectForKey:SHEET_DIVISIONS];
        
        
        for (NSDictionary *divisionDic in divisionsArray)
        {
            divisionName = [[divisionDic objectForKey:DIVISION_ATTRIBUTES] objectForKey:DIVISION_NAME];
            NSArray *classesArray = [divisionDic objectForKey:SHEET_CLASSES];
            
            
            for (NSDictionary *classDic in classesArray)
            {
                NSArray *entriesArray = [classDic objectForKey:SHEET_ENTRIES];
                
                for (NSMutableDictionary *entryDic in entriesArray)
                {
                    NSDictionary *entryAttributeDic = [entryDic objectForKey:CLASS_ATTRIBUTES];                    
                    entryId = [entryAttributeDic objectForKey:ENTRY_ID];
                    
                    if(![entryId isEqualToString:searchID] && ![[entryAttributeDic objectForKey:SHEET_HEADING_EXHIBITOR]isEqualToString:searchID] && ![[entryAttributeDic objectForKey:WEN_KEY]isEqualToString:searchID])
                        continue;
                    
                    if(isAddUpdated)
                    {
                        [self addUpdatedAttributeAndEnableCheckmarkInEntryDic:entryDic atCheckmarkIndex:0];
                    }
                    
                    NSMutableDictionary *searchedClassDic = [[NSMutableDictionary alloc] init];
                    
                    NSMutableDictionary *searchedClassDetailDic = [[NSMutableDictionary alloc] init];
                    [searchedClassDetailDic setObject:departmentName forKey:DEPARTMENT];
                    [searchedClassDetailDic setObject:divisionName forKey:DIVISION];
                    [searchedClassDetailDic setObject:classDic forKey:CLASS];
                    
                    [searchedClassDic setObject:searchedClassDetailDic forKey:CLASS];
                    [searchedClassDic setObject:entryId forKey:ENTRY_ID];
                    
//                    [searchedClassDetailDic release],searchedClassDetailDic = nil;
                    return searchedClassDic;
                }
            }
        }
    }
    return nil;
}


+(NSString *)getCurrentDateInStringWhenRefreshButtonTapAndSaveInUserDefaults
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
//    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
    NSString *date = [dateFormat stringFromDate:today];
    
    [[NSUserDefaults standardUserDefaults]setObject:date forKey:LAST_UPDATED_DATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return date;
}

+(void)addUpdatedAttributeAndEnableCheckmarkInEntryDic:(NSMutableDictionary *)entryDic atCheckmarkIndex:(int)checkmarkIndex
{
    if(!entryDic)
        return;
    
//    NSMutableArray *columnsArray = [entryDic objectForKey:ENTRY_COLUMNS];
//    [columnsArray replaceObjectAtIndex:checkmarkIndex withObject:_YES];
    
    [[entryDic objectForKey:ENTRY_ATTRIBUTES] setObject:[self getCurrentDateInStringWhenRefreshButtonTapAndSaveInUserDefaults] forKey:QRCodeScannerPopoverQuickConfirmModeUpdated];
}

#pragma mark - Helper methods

+(int)getIndexValueOfChekmarkFromSheetDic:(NSDictionary *)sheetDic
{
    NSArray *templateArray = [sheetDic objectForKey:SHEET_TEMPLATE];
    
    for(int i = 0 ; i < [templateArray count] ; i++)
    {
        NSDictionary *templateDic = [templateArray objectAtIndex:i];
        NSString *heading = [templateDic objectForKey:SHEET_HEADER_HEADING];
        
        if([heading isEqualToString:SHEET_HEADING_CHECKMARK])
            return i;
    }
    
    return -1;
}

+(int)getIndexValueOfClubFromSheetDic:(NSDictionary *)sheetDic
{
    NSArray *templateArray = [sheetDic objectForKey:SHEET_TEMPLATE];
    
    for(int i = 0 ; i < [templateArray count] ; i++)
    {
        NSDictionary *templateDic = [templateArray objectAtIndex:i];
        NSString *heading = [templateDic objectForKey:SHEET_HEADER_HEADING];
        
        if([heading isEqualToString:SHEET_HEADING_CLUB])
            return i;
    }
    
    return -1;
}

@end
