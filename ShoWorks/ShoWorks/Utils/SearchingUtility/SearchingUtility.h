//
//  SearchingUtility.h
//  iPadApp
//
//  Created by LeewayHertz on 24/04/13.
//
//

#import <Foundation/Foundation.h>
@class QRScannedModel;

@interface SearchingUtility : NSObject{

}


+(void)getSearchModelsFromSearchText:(NSString *)searchText inSheetDic:(NSMutableDictionary *)sheetDic inSearchModelArray:(NSMutableArray *)searchModelArray;

//+(void)addUpdateAttributeInSheetDic:(NSDictionary *)sheetDic withQRScanModel:(QRScannedModel *)qrScannedModelObj;

+(NSMutableDictionary *)getSearchedClassDicForQRScanModel:(QRScannedModel *)qrScannedModelObj fromSheetDic:(NSDictionary *)sheetDic andIsAddUpdatedAttributeInEntryNode:(BOOL)isAddUpdated;
+(NSMutableDictionary *)getSearchedClassDicForSearchId:(NSString *)searchID fromSheetDic:(NSDictionary *)sheetDic andIsAddUpdatedAttributeInEntryNode:(BOOL)isAddUpdated;
+(NSMutableArray *)searchManualEntry:(NSString *)searchText inSheetDic:(NSMutableDictionary *)sheetDic;
+(int)getIndexValueOfClubFromSheetDic:(NSDictionary *)sheetDic;
@end
