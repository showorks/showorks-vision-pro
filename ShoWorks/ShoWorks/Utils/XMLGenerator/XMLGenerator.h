//
//  XMLGenerator.swift
//  ShoWorks
//
//  Created by Lokesh on 29/07/23.
//


#import <Foundation/Foundation.h>

@interface XMLGenerator : NSObject {
    NSDictionary *sheet;
}

@property (nonatomic, retain) NSDictionary *sheet;

- (NSString *)getXMLString;
- (NSString *)getStringAttributesFromDictionary:(NSDictionary *)attributes;
- (NSString *)getSheetTemplate:(NSArray *)template;
- (NSString *)getSheetItems:(NSArray *)items;
- (NSString *)getSheetDivisions:(NSArray *)divisions;
- (NSString *)getSheetClasses:(NSArray *)classes;
- (NSString *)getSheetEntries:(NSArray *)entries;

@end
