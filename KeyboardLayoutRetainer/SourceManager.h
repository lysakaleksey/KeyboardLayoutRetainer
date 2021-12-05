//
//  SourceManager.h
//  KeyboardLayoutRetainer
//
//  Created by Alexey Lysak on 20/Jul/13.
//  Copyright (c) 2013 Alexey Lysak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

extern NSString * const DEFAULT_INPUT_SOURCE;

@interface SourceManager : NSObject

-(NSString*)getCurrentInputSourceName;
-(void)selectInputSourceByName:(NSString*)name;

@end
