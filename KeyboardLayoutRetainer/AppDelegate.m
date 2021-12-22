//
//  AppDelegate.m
//  KeyboardLayoutSwitcher
//
//  Created by Alexey Lysak on 18/Jul/13.
//  Copyright (c) 2013 Alexey Lysak. All rights reserved.
//

#import "AppDelegate.h"
#import "SourceManager.h"

@implementation AppDelegate

- (id)init {
    self = [super init];
    if (self) {
        _sourceManager = [[SourceManager alloc] init];
    }

    return self;
}

- (void)awakeFromNib {

    // Create the status bar item
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:25.0];
    [_statusItem setMenu:menu];
    [_statusItem setHighlightMode:YES];

    // load the currect language image
    NSImage *image = [NSImage imageNamed:@"StatusIcon"];
    [image setSize:NSMakeSize(20, 20)];
    [_statusItem setImage:image];

    // Init the dictionary
    _retainedLayouts = [NSMutableDictionary dictionary];

#if DEBUG
    NSLog(@"awakeFromNib");
#endif
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
#if DEBUG
    NSLog(@"applicationDidFinishLaunching");
#endif
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
}

- (void)applicationActivated:(NSNotification *)notification {
#if DEBUG
    NSLog(@"============= Application Activated =============");
#endif

    // Take a running application metadata
    NSRunningApplication *currentApplication = (NSRunningApplication *) notification.userInfo[NSWorkspaceApplicationKey];

#if DEBUG
    NSLog(@"applicationActivated => application: %d-%@", currentApplication.processIdentifier, currentApplication.bundleIdentifier);
    //NSLog(@"applicationActivated => current layout: %@", TISCopyCurrentKeyboardInputSource());
#endif

    // Get the current source
    NSString *currentName = [_sourceManager getCurrentInputSourceName];

    // Some previous window - we need to retain current layout
    if (_applicationIdentifier != nil) {
#if DEBUG
        NSLog(@"applicationActivated => previous application %@", _applicationIdentifier);
#endif

        // Save it
        [_retainedLayouts setValue:currentName forKey:_applicationIdentifier];

#if DEBUG
        NSLog(@"applicationActivated => retaining previous layout %@ for %@", currentName, _applicationIdentifier);
#endif
    }

    // Let's take a process id as a key for the dictionary
    _applicationIdentifier = [NSString stringWithFormat:@"%d-%@", currentApplication.processIdentifier, currentApplication.bundleIdentifier];

    // Looking for process id in the dictionary
    NSString *applicationSourceName = _retainedLayouts[_applicationIdentifier];

    // Change the input source layout if found
    if (applicationSourceName == nil) {
        // Set the default input source
        applicationSourceName = DEFAULT_INPUT_SOURCE;

#if DEBUG
        NSLog(@"applicationActivated => no retained. Using default %@", applicationSourceName);
#endif
    }

#if DEBUG
    NSLog(@"applicationActivated => switching layout to: %@", applicationSourceName);
#endif

    // Switching to new layout whether retained or default
    [_sourceManager selectInputSourceByName:applicationSourceName];

#if DEBUG
    NSLog(@"applicationActivated => retained Layouts: %@", _retainedLayouts);
#endif
}

@end
