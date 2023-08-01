//
//  Additions
//  ShoWorks
//
//  Created by Lokesh on 29/07/23.
//


#import <Foundation/Foundation.h>

@interface NSMutableString (XMLEntities)
- (NSMutableString *)xmlSimpleUnescape;
- (NSMutableString *)xmlSimpleEscape;
@end

@interface NSString (XMLEntities)
- (NSString *)xmlSimpleEscape2;
@end

@interface NSData (XMLEntities)
- (NSData *)dataBySimpleUnescaping;
@end
