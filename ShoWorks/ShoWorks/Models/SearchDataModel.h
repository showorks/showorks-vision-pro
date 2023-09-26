//
//  SearchDataModel.h
//  iPadApp
//
//  Created by LeewayHertz on 23/04/13.
//
//

#import <Foundation/Foundation.h>

@interface SearchDataModel : NSObject{
    
}

@property (nonatomic , retain) NSString *departmentName;
@property (nonatomic , retain) NSString *divisionName;
@property (nonatomic , retain) NSString *className;
@property (nonatomic , retain) NSDictionary *classDetailDic;
@property (nonatomic , retain) NSMutableArray *searchedEntryIdArray;
@property (nonatomic , assign) BOOL isSelected;
@property (nonatomic , assign) BOOL allMandatoryDataAvailable;
@property (nonatomic, assign) BOOL isChanged;

@end
