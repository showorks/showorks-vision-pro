//
//  XMLGenerator.swift
//  ShoWorks
//
//  Created by Lokesh on 29/07/23.
//


#import "XMLGenerator.h"
#import "Additions.h"

@implementation XMLGenerator
@synthesize sheet;
- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (NSString *)getXMLString {
    NSMutableString *xml = [NSMutableString string];
    [xml appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [xml appendFormat:@"<Sheet%@>", [self getStringAttributesFromDictionary:[sheet objectForKey:@"Sheet"]]];
    [xml appendFormat:@"<Template>%@</Template>", [self getSheetTemplate:[sheet objectForKey:@"Template"]]];
    [xml appendFormat:@"<Items>%@</Items>", [self getSheetItems:[sheet objectForKey:@"Departments"]]];
    [xml appendString:@"</Sheet>"];
    
    return xml;
}

- (NSString *)getStringAttributesFromDictionary:(NSDictionary *)attributes {
    NSMutableString *str = [NSMutableString string];
    for (NSString *key in [attributes allKeys]) {
        id attr = [attributes objectForKey:key];
        
        if(![attr isKindOfClass:[NSString class]])
            attr = [NSString stringWithFormat:@"%@",attr];
        
        NSString *elem = [NSString stringWithFormat:@" %@=\"%@\"", [key xmlSimpleEscape2], [attr xmlSimpleEscape2]];
        [str appendString:elem];
    }
    
    return str;
}


- (NSString *)getSheetTemplate:(NSArray *)template {
    NSMutableString *str = [NSMutableString string];
    
    for (NSDictionary *col in template)
        [str appendFormat:@"<Column%@/>", [self getStringAttributesFromDictionary:col]];
    
    return str;
}


- (NSString *)getSheetItems:(NSArray *)items {
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *department in items) {
        [str appendFormat:@"<Department%@>", [self getStringAttributesFromDictionary:[department objectForKey:@"Attributes"]]];
        [str appendString:[self getSheetDivisions:[department objectForKey:@"Divisions"]]];     
        [str appendFormat:@"</Department>"];
    }
    return str;
}

- (NSString *)getSheetDivisions:(NSArray *)divisions {
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *divsion in divisions) {
        [str appendFormat:@"<Division%@>", [self getStringAttributesFromDictionary:[divsion objectForKey:@"Attributes"]]];
        [str appendString:[self getSheetClasses:[divsion objectForKey:@"Classes"]]];
        [str appendFormat:@"</Division>"];
    }
    return str;
}

- (NSString *)getSheetClasses:(NSArray *)classes {
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *class in classes) {
        [str appendFormat:@"<Class%@>", [self getStringAttributesFromDictionary:[class objectForKey:@"Attributes"]]];
        [str appendString:[self getSheetEntries:[class objectForKey:@"Entries"]]];
        [str appendFormat:@"</Class>"];
    }
    return str;
}

- (NSString *)getSheetEntries:(NSArray *)entries {
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *entry in entries) {
        [str appendFormat:@"<Entry%@>", [self getStringAttributesFromDictionary:[entry objectForKey:@"Attributes"]]];
        
        for (NSString *item in [entry objectForKey:@"Columns"]) {
            if ([item isEqualToString:@""]) 
                [str appendString:@"<Column/>"];
            else 
                [str appendFormat:@"<Column>%@</Column>", [item xmlSimpleEscape2]];
        }
        
        [str appendFormat:@"</Entry>"];
    }
    return str;
}

@end
