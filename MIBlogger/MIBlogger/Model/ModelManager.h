//
//  ModelManager.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralPurposeModel.h"
#import "BlogSummaryModel.h"
#import "ArticleSummaryModel.h"
#import "ArticleModel.h"
#import "APIManager.h"

@interface ModelManager : NSObject

@property (nonatomic, retain) GeneralPurposeModel *generalPurposeModel;
@property (nonatomic, retain) BlogSummaryModel *blogSummaryModel;
@property (nonatomic, retain) ArticleSummaryModel *articleSummaryModel;
@property (nonatomic, retain) ArticleModel *articleModel;

+ (ModelManager *)sharedInstance;
- (id)init UNAVAILABLE_ATTRIBUTE;

@end
