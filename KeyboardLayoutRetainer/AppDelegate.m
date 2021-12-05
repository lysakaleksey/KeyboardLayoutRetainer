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

-(id)init
{
    self = [super init];
    if(self)
    {
        _sourceManager = [[SourceManager alloc] init];
    }
    
    return self;
}

-(void)awakeFromNib {
    
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

-(void)applicationDidFinishLaunching:(NSNotification *)notification
{
    #if DEBUG
    NSLog(@"applicationDidFinishLaunching");
    #endif
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(applicationActivated:)
                                                               name:NSWorkspaceDidActivateApplicationNotification
                                                             object:nil];
}

-(void)applicationWillTerminate:(NSNotification *)notification
{
    #if DEBUG
    NSLog(@"applicationWillTerminate");
    #endif
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
}

-(void)applicationActivated:(NSNotification*)notification
{
    #if DEBUG
    NSLog(@"============= Application Activated =============");
    #endif
    
    // Take a running application metadata
    NSRunningApplication *currentApplication = (NSRunningApplication*)[notification.userInfo objectForKey:NSWorkspaceApplicationKey];

    #if DEBUG
    NSLog(@"applicationActivated => application: %d-%@", currentApplication.processIdentifier,currentApplication.bundleIdentifier);
    NSLog(@"applicationActivated => current layouot: %@", TISCopyCurrentKeyboardInputSource());
    #endif
    
    // Get the current source
    NSString *currentName = [_sourceManager getCurrentInputSourceName];
    
    // Some previous window - we need to retain current layout
    if (_applicationIdentifier != nil)
    {
        #if DEBUG
        NSLog(@"applicationActivated => previous found %@", _applicationIdentifier);
        #endif
    
        // Save it
        [_retainedLayouts setValue:currentName forKey:_applicationIdentifier];
    
        #if DEBUG
        NSLog(@"applicationActivated => retaining previous layout %@ for %@", currentName, _applicationIdentifier);
        #endif
    }

    // Let's take a process id as a key for the dictionary
    _applicationIdentifier = [NSString stringWithFormat:@"%d-%@", currentApplication.processIdentifier,currentApplication.bundleIdentifier];
    
    // Looking for process id in the dictionary
    NSString *applicationSourceName = [_retainedLayouts objectForKey:_applicationIdentifier];
    
    // Change the input source layout if found
    if (applicationSourceName == nil)
    {
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

void OnCurrentTextInputSourceChange(CFNotificationCenterRef aCenter, void* aObserver, CFStringRef aName, const void* aObject, CFDictionaryRef aUserInfo)
{
    [(__bridge id)aObserver inputSourceChanged];
}

-(void)inputSourceChanged
{
    // Get the current input source
    //TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
    
    #if DEBUG
    NSLog(@"inputSourceChanged => current input source: %@", [_sourceManager getCurrentInputSourceName]);
    #endif
    
    /*NSString *currentName = [_sourceManager getInputSourceName:currentSource];
    
    // Assign the current layout to the current active process
    if (_applicationIdentifier != nil)
    {
        // Save it in the dictionary
        [_retainedLayouts setValue:currentName forKey:_applicationIdentifier];
   
        #if DEBUG
        NSLog(@"inputSourceChanged => retaining %@ for %@", currentName, _applicationIdentifier);
        #endif
    }
    
    #if DEBUG
    NSLog(@"applicationActivated => retained Layouts: %@", _retainedLayouts);
    #endif
    */
}

/*
-(void)loadMenu
{
    NSUInteger n = [[menu itemArray] count];
    for (int i=0;i<n-2;i++) {
        [menu removeItemAtIndex:0];
    }
    
    // Reverse order just for have U.S. at the top. No need extra logic of sorting, etc.
    for(NSInteger i = _inputLayoutList.count-1; i >= 0 ; i--)
    {
        TISInputSourceRef sourceRef = (__bridge TISInputSourceRef)([_inputLayoutList objectAtIndex:i]);
    
        NSString *sourceName = [self getInputSourceName:sourceRef];
        #if DEBUG
        NSLog(@"loadMenu => source name: %@", sourceName);
        #endif
    
        NSImage *image = [self getInputSourceImage:sourceRef];
            
        NSMenuItem *menuItem = [menu insertItemWithTitle:sourceName action:false keyEquivalent:@"" atIndex:0];
        [menuItem setTarget:self];
        [menuItem setImage:image];
        [menuItem setEnabled:false];
        [menuItem setAction:@selector(menuItemAction:)];
        [menuItem setRepresentedObject:(__bridge id)(sourceRef)];
    }
}

-(void)menuItemAction:(NSMenuItem *)sender
{
    //NSLog(@"sender: %@", sender);
    TISInputSourceRef requiredSource = (__bridge TISInputSourceRef)(sender.representedObject);
    TISInputSourceRef currentSource = TISCopyCurrentKeyboardInputSource();
    
    //Let's compare based on the name
    NSString *requiredName = [self getInputSourceName:requiredSource];
    NSString *currentName = [self getInputSourceName:currentSource];
    
    #if DEBUG
    NSLog(@"menuItemAction => currentName: %@", currentName);
    NSLog(@"menuItemAction => requiredName: %@", requiredName);
    #endif
    
    // If the current <> required - then need to activate
    if (![currentName isEqualToString:requiredName])
    {
        #if DEBUG
        NSLog(@"menuItemAction => Switching layout to: %@", requiredName);
        #endif
    
        TISSelectInputSource(requiredSource);
    }
}

*/


@end
