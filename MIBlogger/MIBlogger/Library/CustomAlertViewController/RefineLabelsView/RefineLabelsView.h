//
//  RefineLabelsView.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/08/01.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefineLabelsView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

// インスタンスを返す
+ (instancetype)refineLabelsView;
// 高さを返す
+ (CGFloat)refineLabelsViewHeight;

@end
