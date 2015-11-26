//
//  HTMLParser.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/17.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTMLParser : NSObject

+ (NSString *)parseHTMLFromURL:(NSString *)urlString;

@end
