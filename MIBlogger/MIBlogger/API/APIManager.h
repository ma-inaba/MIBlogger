//
//  APIManager.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/10.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface APIManager : NSObject

@property (nonatomic, retain) GTMOAuth2Authentication *auth;

- (void)startLogin:(BOOL)logout;
// ブログ一覧取得
- (void)requestListByUser;
// 記事一覧取得
- (void)requestPagesList:(NSString  *)pageToken;
// タグ一覧取得
- (void)requestLabelList;

@end
