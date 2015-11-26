//
//  ArticleSummaryModel.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "ArticleSummaryModel.h"

@implementation ArticleSummaryModel

- (id)init {
    
    if ([super init]) {
        [self settingArray];
    }
    
    return self;
}

- (void)settingArray {
    
    self.articleSortTitleArray = [NSArray arrayWithObjects:@"新着順", @"投稿順", @"コメントが多い順", nil];
    self.selectedLabels = [[NSMutableArray alloc] init];
}

- (void)requestArticleList {
    
    APIManager *apiManager = [[APIManager alloc] init];
    [apiManager requestPagesList:nil];
}

- (void)requestArticleListWithPageToken:(NSString *)pageToken {
    
    APIManager *apiManager = [[APIManager alloc] init];
    [apiManager requestPagesList:pageToken];
}

- (void)requestLabelList {
    APIManager *apiManager = [[APIManager alloc] init];
    [apiManager requestLabelList];
}
@end
