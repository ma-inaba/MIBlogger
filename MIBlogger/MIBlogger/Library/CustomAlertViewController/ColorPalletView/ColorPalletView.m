//
//  ColorPalletView.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "ColorPalletView.h"

@implementation ColorPalletView

- (void)_init {
    
    // initialize
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // 初期設定など
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *selectView = touch.view;
    
    if (selectView.tag == 0) {
        return;
    }
    
    for (int i = 0; i < [self.colorCollection count]; i++) {
        UIView *colorTile = [self.colorCollection objectAtIndex:i];
        if (colorTile.tag == selectView.tag) {
            colorTile.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        } else {
            colorTile.transform = CGAffineTransformIdentity;
        }
    }
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    CGFloat red, green, blue, alpha;
    [selectView.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    modelManager.blogSummaryModel.themeColorRed = red;
    modelManager.blogSummaryModel.themeColorGreen = green;
    modelManager.blogSummaryModel.themeColorBlue = blue;
    modelManager.blogSummaryModel.themeColorAlpha = alpha;
    modelManager.blogSummaryModel.themeColor = selectView.backgroundColor;
}

+ (instancetype)colorPalletView {
    
    // xib ファイルから ColorPalletView のインスタンスを得る
    UINib *nib = [UINib nibWithNibName:@"ColorPalletView" bundle:nil];
    ColorPalletView *colorPallet = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    return colorPallet;
}

+ (CGFloat)colorPalletHeight {
    ColorPalletView *colorPallet = [self colorPalletView];
    return colorPallet.frame.size.height;
}
@end
