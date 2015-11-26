//
//  MIDefaultButton.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "MIDefaultButton.h"

@implementation MIDefaultButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self settingLayer];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self settingLayer];
    }
    return self;
}

//背景とタイトルの編集が出来るようにする
- (id)initWithFrame:(CGRect)frame label:(NSString *)title bkgcolor:(UIColor *)rgba {
    
    self = [super initWithFrame:frame];
    if(self){
        // Layerの設定
        [self settingLayer];
    }
    return self;
}
- (void)settingLayer {

    UIColor *themeColor = [GeneralPurposeUtility readThemeColor];
    
    self.titleLabel.font = [UIFont boldSystemFontOfSize:13];

    if (self.tag == 1) {
        // 輪郭線を描く
        [self.layer setCornerRadius:15.0];
        [self.layer setBorderColor:themeColor.CGColor];
        [self.layer setBorderWidth:2.0];
    }
    
    // 通常時のタイトルの色
    [self setTitleColor:themeColor forState:UIControlStateNormal];
    // 押下時のタイトルの色
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
}

@end
