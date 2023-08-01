//
//  Additions.swift
//  ShoWorks
//
//  Created by Lokesh on 29/07/23.
//


#import "Additions.h"

@implementation NSMutableString (XMLEntities)

- (NSMutableString *)xmlSimpleUnescape
{
    [self replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x27;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x39;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x92;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x96;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#xD;"   withString:@"\n"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    return self;
}

- (NSMutableString *)xmlSimpleEscape
{
    [self replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"'"  withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    
    return self;
}

@end

@implementation NSString (XMLEntities)
- (NSString *)xmlSimpleEscape2 {
    return [[NSMutableString stringWithString:self] xmlSimpleEscape];
}

@end

@implementation NSData (XMLEntities)
- (NSData *)dataBySimpleUnescaping {
    NSMutableString *dataString = [[NSMutableString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    [dataString xmlSimpleUnescape];
    return [dataString dataUsingEncoding:NSUTF8StringEncoding];
}
@end
