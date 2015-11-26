//
//  SortView.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortView : UIView
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;

// インスタンスを返す
+ (instancetype)sortView;
// 高さを返す
+ (CGFloat)sortViewHeight;

@end
