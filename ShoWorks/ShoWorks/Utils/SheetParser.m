#import "SheetParser.h"

#define SHEET_UPDATED_BY_VERSION @"UpdatedByVersion"
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

#define SHEET @"Sheet"
#define VERSION @"Version"


@implementation SheetParser
@synthesize itemsArray, templateArray, sheetAttributes, delegate, data, filename;

- (id)initWithDelegate:(id <SheetParserDelegate>)del data:(NSData *)sheetData {
    self = [super init];
    if (self) {
        
        [self setData:sheetData];
        [self setDelegate:del];
        [self setItemsArray:[NSMutableArray array]];
        [self setTemplateArray:[NSMutableArray array]];
        
        mainPos = kInUnknown;
    }
    
    return self;
}

//- (void)dealloc {
//    [itemsArray release];
//    [templateArray release];
//    [delegate release];
//    
//    [super dealloc];
//}

- (void)parse {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
//    [parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:SHEET]) {
        [self setSheetAttributes:attributeDict];
    } else if ([elementName isEqualToString:@"Template"]) {
        mainPos = kInTemplate;
    } else if ([elementName isEqualToString:@"Items"]) {
        maxSubPos = [templateArray count];
        mainPos = kInItems;
    }
    
    if ([elementName isEqualToString:@"Department"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dict setObject:attributeDict forKey:@"Attributes"];
        [dict setObject:[NSMutableArray array] forKey:SHEET_DIVISIONS];
        [itemsArray addObject:dict];
        
        //Fixed by Aditya..
//        [dict release],
        dict = nil;
    } else if ([elementName isEqualToString:@"Division"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dict setObject:attributeDict forKey:@"Attributes"];
        [dict setObject:[NSMutableArray array] forKey:SHEET_CLASSES];
        [[[itemsArray lastObject] objectForKey:SHEET_DIVISIONS] addObject:dict];
        
        //Fixed by Aditya..
//        [dict release],
        dict = nil;
    } else if ([elementName isEqualToString:@"Class"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dict setObject:attributeDict forKey:@"Attributes"];
        [dict setObject:[NSMutableArray array] forKey:SHEET_ENTRIES];
        [[[[[itemsArray lastObject] objectForKey:SHEET_DIVISIONS] lastObject] objectForKey:SHEET_CLASSES] addObject:dict];
        
        //Fixed by Aditya..
//        [dict release],
        dict = nil;
    } else if ([elementName isEqualToString:@"Column"]) {
        if (mainPos == kInTemplate) {
            [templateArray addObject:attributeDict];
        } else if (mainPos == kInItems) {
            subPos++;
            subPos %= maxSubPos;
        }
    } else if ([elementName isEqualToString:@"Entry"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dict setObject:attributeDict forKey:@"Attributes"];
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:maxSubPos];
        for (int i=0; i<maxSubPos; i++) {
            [columns addObject:@""];
        }
        [dict setObject:columns forKey:@"Columns"];
        [[[[[[[itemsArray lastObject] objectForKey:SHEET_DIVISIONS] lastObject] objectForKey:SHEET_CLASSES] lastObject] objectForKey:SHEET_ENTRIES] addObject:dict];
        subPos = -1;
        
        //Fixed by Aditya..
//        [dict release],
        dict = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
        
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (mainPos == kInItems) {
        NSDictionary *dict = [[[[[[[itemsArray lastObject] objectForKey:SHEET_DIVISIONS] lastObject] objectForKey:SHEET_CLASSES] lastObject] objectForKey:SHEET_ENTRIES] lastObject];
        
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        if(subPos == -1 || string.length == 0)
            return;
        
        NSMutableArray *columnsArray = [dict objectForKey:@"Columns"];
        [columnsArray replaceObjectAtIndex:subPos withObject:string];
    } 
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:itemsArray forKey:SHEET_DEPARTMENTS];
    [dict setObject:templateArray forKey:@"Template"];
    [dict setObject:sheetAttributes forKey:SHEET];
    if (filename != nil) {
        [dict setObject:filename forKey:SHEET_FILE_NAME];
    }
    
    
    [delegate didFinishParsingWithDictionary:dict];
}


@end
