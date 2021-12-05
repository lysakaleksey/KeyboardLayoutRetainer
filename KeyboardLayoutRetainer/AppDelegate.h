//
//  AppDelegate.h
//  KeyboardLayoutSwitcher
//
//  Created by Alexey Lysak on 18/Jul/13.
//  Copyright (c) 2013 Alexey Lysak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SourceManager.h"
 
@interface AppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
    IBOutlet NSMenu *menu;
}
    @property SourceManager *sourceManager;
    @property NSStatusItem *statusItem;
    @property NSString* applicationIdentifier;
    @property NSMutableDictionary *retainedLayouts;
@end
