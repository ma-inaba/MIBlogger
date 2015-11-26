//
//  ModelManager.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "ModelManager.h"

@implementation ModelManager

static ModelManager *_instance;

+ (void)initialize {
    
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [[ModelManager alloc] initInternal];
        }
    }
}

+ (ModelManager *)sharedInstance {
    
    return _instance;
}

- (id)init {
    
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initInternal {
    
    self = [super init];
    // 初期化処理
    self.blogSummaryModel = [[BlogSummaryModel alloc] init];
    self.generalPurposeModel = [[GeneralPurposeModel alloc] init];
    self.articleSummaryModel = [[ArticleSummaryModel alloc] init];
    self.articleModel = [[ArticleModel alloc] init];
    return self;
}

@end
