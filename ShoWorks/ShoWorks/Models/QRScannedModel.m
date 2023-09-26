//
//  QRScannedModel.m
//  iPadApp
//
//  Created by LeewayHertz on 05/05/13.
//
//

#import "QRScannedModel.h"

@implementation QRScannedModel

-(id)initWithCoder:(NSCoder*)coder{
    
	if (self=[super init])
    {
		[self setWenOrEntryId:[coder decodeObject]];
        [self setSearchKey:[coder decodeIntForKey:@"IndexOfColumn"]];
        [self setQrImage:[coder decodeObject]];
    }
	return self;
}

-(void)encodeWithCoder:(NSCoder*)coder{
    
	[coder encodeObject:_wenOrEntryId];
    [coder encodeInt:_searchKey forKey:@"IndexOfColumn"];
    [coder encodeObject:_qrImage];
}

@end
