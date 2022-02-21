#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface SourceManager : NSObject

- (NSString *)getCurrentInputSourceName;

- (void)selectInputSourceByName:(NSString *)name;

@end
