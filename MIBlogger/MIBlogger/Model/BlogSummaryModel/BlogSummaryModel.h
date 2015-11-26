//
//  BlogSummaryModel.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface BlogSummaryModel : NSObject

- (void)startLogin:(BOOL)logout;
- (void)requestBlogList;

@property float themeColorRed;
@property float themeColorGreen;
@property float themeColorBlue;
@property float themeColorAlpha;
@property (nonatomic, retain) UIColor *themeColor;  // これをKVO監視し、ViewControllerでテーマカラーを更新する
@property (nonatomic, retain) NSArray *blogSortTitleArray;  // これをブログソートテーブルのtitleに設定する
@property (nonatomic, retain) GTMOAuth2ViewControllerTouch *oAuth2ViewCon;   //これをログイン画面として表示する
@property (nonatomic, retain) GTMOAuth2Authentication *auth;    //authトークン

@property (nonatomic, retain) NSDictionary *myBlogsDict;    // 取得した自分がフォローするブログ一覧

@end
