#import <Foundation/Foundation.h>

#define kInTemplate 0
#define kInItems 1
#define kInUnknown 2

@protocol SheetParserDelegate;
@interface SheetParser : NSObject <NSXMLParserDelegate> {
    
    NSString *filename;
    
    NSMutableArray *itemsArray;
    NSMutableArray *templateArray;
    NSDictionary *sheetAttributes;
    
    NSData *data;
    
//    id<SheetParserDelegate>delegate;
    
    int mainPos;
    int maxSubPos;
    int subPos;
}

@property (nonatomic, retain) NSMutableArray *itemsArray;
@property (nonatomic, retain) NSMutableArray *templateArray;

// Fixed by Aditya.. Retain to assign
// Cause: Dealloc of sheetdetailviewcontroller is not being called..
@property (nonatomic, assign) id<SheetParserDelegate> delegate;
@property (nonatomic, retain) NSDictionary *sheetAttributes;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSString *filename;

- (id)initWithDelegate:(id <SheetParserDelegate>)del data:(NSData *)data;
- (void)parse;

@end

@protocol SheetParserDelegate <NSObject>
- (void)didFinishParsingWithDictionary:(NSMutableDictionary *)dictionary;
@end
