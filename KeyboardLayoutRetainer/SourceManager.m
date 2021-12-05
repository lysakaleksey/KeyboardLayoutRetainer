//
//  SourceManager.m
//  KeyboardLayoutRetainer
//
//  Created by Alexey Lysak on 20/Jul/13.
//  Copyright (c) 2013 Alexey Lysak. All rights reserved.
//

#import "SourceManager.h"

NSString * const DEFAULT_INPUT_SOURCE = @"U.S.";

@implementation SourceManager

-(TISInputSourceRef)getInputSourceByName:(NSString*)name
{
    NSDictionary *filter = [NSDictionary dictionaryWithObject:(NSString *)kTISCategoryKeyboardInputSource
                                                       forKey:(NSString *)kTISPropertyInputSourceCategory];
    
    CFArrayRef cfInputList = (TISCreateInputSourceList((__bridge CFDictionaryRef)filter,FALSE));
    
    TISInputSourceRef result = nil;
    
    // The default is U.S.
    for (int i = 0; i < CFArrayGetCount(cfInputList); ++i)
    {
        TISInputSourceRef nextInputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(cfInputList, i);
    
        NSString *inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(nextInputSource, kTISPropertyLocalizedName));

        // If the default equal to the current - save it to result and exit
        if ([inputSourceName isEqualToString:name])
        {
            result = nextInputSource;
            break;
        }
    }

    return result;
}

-(NSString*)getInputSourceName:(TISInputSourceRef)source
{
    NSString *name = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyLocalizedName));    
    return name;
}

-(NSImage*)getInputSourceImage:(TISInputSourceRef)source
{
    IconRef icon = TISGetInputSourceProperty(source, kTISPropertyIconRef);
    NSImage *image = [[NSImage alloc] initWithIconRef:icon];
    return image;
}

-(void)selectInputSourceByName:(NSString*)name
{
    NSDictionary *filter = [NSDictionary dictionaryWithObject:(NSString *)kTISCategoryKeyboardInputSource
                                                       forKey:(NSString *)kTISPropertyInputSourceCategory];
    
    CFArrayRef cfInputList = (TISCreateInputSourceList((__bridge CFDictionaryRef)filter,FALSE));
    
    // The default is U.S.
    for (int i = 0; i < CFArrayGetCount(cfInputList); ++i)
    {
        TISInputSourceRef inputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(cfInputList, i);
    
        NSString *inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));

        // If the default equal to the current - save it to result and exit
        if ([inputSourceName isEqualToString:name])
        {
            TISSelectInputSource(inputSource);
            [NSThread sleepForTimeInterval:0.1];
            break;
        }
    }
    CFRelease(cfInputList);
}

-(NSString*)getCurrentInputSourceName
{
    TISInputSourceRef currentInputSource = TISCopyCurrentKeyboardInputSource();
    NSString *inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(currentInputSource, kTISPropertyLocalizedName));
    CFRelease(currentInputSource);
    
    return inputSourceName;
}

@end
