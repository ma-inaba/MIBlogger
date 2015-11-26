//
//  ColorPalletView.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPalletView : UIView

// インスタンスを返す
+ (instancetype)colorPalletView;
// 高さを返す
+ (CGFloat)colorPalletHeight;

@property (nonatomic, retain) UIColor *selectColor;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colorCollection;

@end
