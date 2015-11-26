//
//  BlogSummaryModel.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "BlogSummaryModel.h"

@implementation BlogSummaryModel

- (id)init {
    
    if ([super init]) {
        [self settingArray];
    }
    
    return self;
}

- (void)settingArray {
    
    self.blogSortTitleArray = [NSArray arrayWithObjects:@"名前順", @"お気に入り順", @"新着記事順", nil];
}

- (void)startLogin:(BOOL)logout {
    
    APIManager *apiManager = [[APIManager alloc] init];
    [apiManager startLogin:(BOOL)logout];
}

- (void)requestBlogList {
    
    APIManager *apiManager = [[APIManager alloc] init];
    [apiManager requestListByUser];
}
@end
