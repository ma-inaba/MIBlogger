//
//  HTMLParser.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/17.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "HTMLParser.h"

@implementation HTMLParser

+ (NSString *)parseHTMLFromURL:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    if (html == nil) {
        html = [NSString stringWithContentsOfURL:url encoding:NSShiftJISStringEncoding error:nil];
    }
    return html;
}

@end
