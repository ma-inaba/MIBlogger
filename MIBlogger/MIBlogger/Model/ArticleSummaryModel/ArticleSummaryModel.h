//
//  ArticleSummaryModel.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleSummaryModel : NSObject

- (void)requestArticleList;
- (void)requestArticleListWithPageToken:(NSString *)pageToken;
- (void)requestLabelList;


@property (nonatomic, retain) NSArray *articleSortTitleArray;   // これを記事ソートテーブルのtitleに設定する
@property (nonatomic, retain) NSDictionary *selectedBlogDict;   // 選択したブログ
@property (nonatomic, retain) NSArray *blogArticleArray;        // 選択したブログの記事一覧
@property (nonatomic, retain) NSArray *articleThumbnailArray;   // 選択したブログの記事サムネイル一覧
@property (nonatomic, retain) NSString *nextPageToken;          // 記事一覧の次ページトークン
@property (nonatomic, retain) NSArray *allLabels;               // ブログのタグ一覧
@property (nonatomic, retain) NSMutableArray *selectedLabels;          // 選択したタグ一覧

@end
