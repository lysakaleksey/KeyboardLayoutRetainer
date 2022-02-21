#import <Cocoa/Cocoa.h>
#import "SourceManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    IBOutlet NSMenu *menu;
}
@property NSMutableDictionary *retainedLayouts;
@property SourceManager *sourceManager;
@property NSStatusItem *statusItem;
@property NSString *applicationIdentifier;
@end
