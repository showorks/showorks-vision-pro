//
//  QRScannedModel.h
//  iPadApp
//
//  Created by LeewayHertz on 05/05/13.
//
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
typedef enum{
    
    ENTRYID,
    WEN,
    EXHIBITOR,
    EID,
    CLUB
}SearchKey;

@interface QRScannedModel : NSObject{
    
}

//@property(nonatomic , retain) NSString *department;
//@property(nonatomic , retain) NSString *division;
//@property(nonatomic , retain) NSString *className;
//@property(nonatomic , retain) NSString *exhibitor;
@property(nonatomic , retain) NSString *wenOrEntryId;
@property(nonatomic , assign) SearchKey searchKey;
@property(nonatomic , retain) UIImage *qrImage;
//@property(nonatomic , retain) NSString *club;
//@property(nonatomic , retain) NSString *descriptionText;
//@property(nonatomic , retain) NSString *place;
//@property(nonatomic , retain) NSString *ribbon;

@end
