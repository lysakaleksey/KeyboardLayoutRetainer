#import "SourceManager.h"

@implementation SourceManager

//-(TISInputSourceRef)getInputSourceByName:(NSString*)name
//{
//    NSDictionary *filter = @{(NSString *) kTISPropertyInputSourceCategory: (NSString *) kTISCategoryKeyboardInputSource};
//    CFArrayRef cfInputList = (TISCreateInputSourceList((__bridge CFDictionaryRef)filter,FALSE));
//    TISInputSourceRef result = nil;
//    // The default is U.S.
//    for (int i = 0; i < CFArrayGetCount(cfInputList); ++i)
//    {
//        TISInputSourceRef nextInputSource = (TISInputSourceRef)CFArrayGetValueAtIndex(cfInputList, i);
//        NSString *inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(nextInputSource, kTISPropertyLocalizedName));
//        // If the default equal to the current - save it to result and exit
//        if ([inputSourceName isEqualToString:name])
//        {
//            result = nextInputSource;
//            break;
//        }
//    }
//    return result;
//}

//-(NSString*)getInputSourceName:(TISInputSourceRef)source
//{
//    NSString *name = (__bridge NSString *)(TISGetInputSourceProperty(source, kTISPropertyLocalizedName));
//    return name;
//}
//
//-(NSImage*)getInputSourceImage:(TISInputSourceRef)source
//{
//    IconRef icon = TISGetInputSourceProperty(source, kTISPropertyIconRef);
//    NSImage *image = [[NSImage alloc] initWithIconRef:icon];
//    return image;
//}
- (void)selectInputSourceByName:(NSString *)name {
    CFArrayRef cfInputList = nil;
    @try {
        NSDictionary *filter = @{(NSString *) kTISPropertyInputSourceCategory: (NSString *) kTISCategoryKeyboardInputSource};
        cfInputList = TISCreateInputSourceList((__bridge CFDictionaryRef) filter, FALSE);

        for (int i = 0; i < CFArrayGetCount(cfInputList); ++i) {
            TISInputSourceRef inputSource = nil;
            @try {
                inputSource = (TISInputSourceRef) CFArrayGetValueAtIndex(cfInputList, i);
                NSString *inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
                // If the default equal to the current - save it to result and exit
                if ([inputSourceName isEqualToString:name]) {
                    TISSelectInputSource(inputSource);
                    //[NSThread sleepForTimeInterval:0.1];
                    break;
                }
            } @finally {
                //CFRelease(inputSource);
            }
        }
    } @finally {
        CFRelease(cfInputList);
    }
}

- (NSString *)getCurrentInputSourceName {
    NSString *inputSourceName = nil;
    TISInputSourceRef inputSource = nil;
    @try {
        inputSource = TISCopyCurrentKeyboardInputSource();
        inputSourceName = CFBridgingRelease(TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName));
    } @finally {
        CFRelease(inputSource);
    }
    return [NSString stringWithString:inputSourceName];
}

@end
