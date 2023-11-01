//
//  AppDelegate.m
//  KeyboardLayoutSwitcher
//
//  Created by Alexey Lysak on 18/Jul/13.
//  Copyright (c) 2013 Alexey Lysak. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id)init {
    self = [super init];
    if (self) {
        _sourceManager = [[SourceManager alloc] init];
        _retainedLayouts = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)awakeFromNib {
    // Create the status bar item
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:25.0];
    [_statusItem setMenu:menu];
    [_statusItem setHighlightMode:YES];

    // load the current language image
    NSImage *image = [NSImage imageNamed:@"StatusIcon"];
    [image setSize:NSMakeSize(20, 20)];
    [_statusItem setImage:image];

#if DEBUG
    NSLog(@"awakeFromNib");
#endif
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
#if DEBUG
    NSLog(@"applicationDidFinishLaunching");
#endif
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(applicationActivated:)
//                                                 name:NSWorkspaceDidActivateApplicationNotification
//                                               object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(applicationActivated:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
#if DEBUG
    NSLog(@"applicationWillTerminate");
#endif
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationActivated:(NSNotification *)notification {
    @try {
#if DEBUG
        NSLog(@"============= Application Activated =============");
#endif
        // Take a running application metadata
        NSRunningApplication *currentApplication = (NSRunningApplication *) notification.userInfo[NSWorkspaceApplicationKey];
        if (currentApplication == nil) {
#if DEBUG
            NSLog(@"applicationActivated => No application");
#endif
            return;
        }
#if DEBUG
        NSLog(@"applicationActivated => application: %d-%@", currentApplication.processIdentifier, currentApplication.bundleIdentifier);
#endif

        if ([currentApplication.bundleIdentifier hasSuffix:@"KeyboardLayoutRetainer"]) {
#if DEBUG
            NSLog(@"applicationActivated => Myself, skipping");
#endif
            return;
        }

        // Previous app - we need to retain app layout
        NSString *currentInputSourceName = nil;
        if (_applicationIdentifier != nil) {
#if DEBUG
            NSLog(@"applicationActivated => previous application %@", _applicationIdentifier);
#endif

            // Get the current source
            currentInputSourceName = [_sourceManager getCurrentInputSourceName];

            // Save it
            [_retainedLayouts setValue:currentInputSourceName forKey:_applicationIdentifier];
#if DEBUG
            NSLog(@"applicationActivated => retaining previous layout %@ for %@", currentInputSourceName, _applicationIdentifier);
#endif
        }

        // Let's take a process id as a key for the dictionary
        _applicationIdentifier = [NSString stringWithFormat:@"%d-%@", currentApplication.processIdentifier, currentApplication.bundleIdentifier];

        // Looking for process id in the dictionary
        NSString *targetInputSourceName = _retainedLayouts[_applicationIdentifier];

        // Change the input source layout if found
        if (targetInputSourceName == nil) {
            // Set the default input source
            targetInputSourceName = @"ABC";
#if DEBUG
            NSLog(@"applicationActivated => no retained. Using default %@", targetInputSourceName);
#endif
        }

        // Switching to new layout whether retained or default
        @try {
            if (currentInputSourceName != nil && targetInputSourceName != nil && ![targetInputSourceName isEqualToString:currentInputSourceName]) {
#if DEBUG
                NSLog(@"applicationActivated => switching layout to: %@", targetInputSourceName);
#endif
                [_sourceManager selectInputSourceByName:targetInputSourceName];
            }
        } @catch (NSException *exception) {
#if DEBUG
            NSLog(@"applicationActivated => selectInputSourceByName crashed. Exception: %@", exception.name);
            NSLog(@"applicationActivated => selectInputSourceByName crashed. Reason: %@", targetInputSourceName);
#endif
        }

#if DEBUG
        NSLog(@"applicationActivated => retained Layouts: %@", _retainedLayouts);
#endif
    } @catch (NSException *exception) {
#if DEBUG
        NSLog(@"applicationActivated => crashed. Exception: %@", exception.name);
        NSLog(@"applicationActivated => crashed. Reason: %@", exception.reason);
#endif
    }
}

@end
