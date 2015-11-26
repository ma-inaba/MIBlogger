//
//  CustomAlertViewController.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "CustomAlertViewController.h"
#import "ColorPalletView.h"
#import "SortView.h"
#import "RefineLabelsView.h"

#define kDefaultBaseViewHeight 150
#define kDefaultMessageLabelHeight 21
#define kDefaultContentsViewHeight 35

@interface CustomAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baseViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betweenCancelOKMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelHeight;

@end

@implementation CustomAlertViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self settingValue];
    [self settingView];
    [self settingData];
    self.baseView.transform = CGAffineTransformMakeScale(1.1, 1.1);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self settingAnimation];
}

- (void)settingView {
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];    
    if (self.mode == AlertModeColorPallet) {
        ColorPalletView *colorPalletView = [ColorPalletView colorPalletView];
        [self.contentsView addSubview:colorPalletView];
        colorPalletView.translatesAutoresizingMaskIntoConstraints = NO;
        [GeneralPurposeUtility addAutoLayoutFullScreen:self.contentsView addALView:colorPalletView];
    } else if (self.mode == AlertModeSortBlog) {
        SortView *sortView = [SortView sortView];
        [self.contentsView addSubview:sortView];
        sortView.translatesAutoresizingMaskIntoConstraints = NO;
        [GeneralPurposeUtility addAutoLayoutFullScreen:self.contentsView addALView:sortView];
    } else if (self.mode == AlertModeSortArticle) {
        SortView *sortView = [SortView sortView];
        [self.contentsView addSubview:sortView];
        sortView.translatesAutoresizingMaskIntoConstraints = NO;
        [GeneralPurposeUtility addAutoLayoutFullScreen:self.contentsView addALView:sortView];
    } else if (self.mode == AlertModeRefineArticle) {
        RefineLabelsView *refineLabelsView = [RefineLabelsView refineLabelsView];
        [self.contentsView addSubview:refineLabelsView];
        refineLabelsView.translatesAutoresizingMaskIntoConstraints = NO;
        [GeneralPurposeUtility addAutoLayoutFullScreen:self.contentsView addALView:refineLabelsView];
    }
}

- (void)settingValue {
    
    // 文字操作
    self.titleLabel.text = self.alertTitle;
    self.messageLabel.text = self.alertMessage;
    [self.messageLabel sizeToFit];
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [self.okButton setTitle:self.okButtonTitle forState:UIControlStateNormal];

    // ボタン間隔の調整
    self.buttonMargin.constant = self.buttonMargin.constant/2;
    self.betweenCancelOKMargin.constant = self.betweenCancelOKMargin.constant/2;
    
    // constantの調整
    self.messageLabelHeight.constant = self.messageLabel.frame.size.height;
    
    float height = 20.0f;
    if (self.mode == AlertModeColorPallet) {
        height = [ColorPalletView colorPalletHeight];
    } else if (self.mode == AlertModeSortBlog) {
        height = [SortView sortViewHeight];
    } else if (self.mode == AlertModeSortArticle) {
        height = [SortView sortViewHeight];
    } else if (self.mode == AlertModeRefineArticle) {
        height = [RefineLabelsView refineLabelsViewHeight];
        
    }
    
    self.contentsViewHeight.constant = height;
    self.baseViewHeight.constant = kDefaultBaseViewHeight - kDefaultContentsViewHeight + height - kDefaultMessageLabelHeight + self.messageLabelHeight.constant;
    
}

- (void)settingData {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    if (self.mode == AlertModeColorPallet) {
    } else if (self.mode == AlertModeSortBlog) {
    } else if (self.mode == AlertModeSortArticle) {
    } else if (self.mode == AlertModeRefineArticle) {
        modelManager.articleSummaryModel.selectedLabels = [[NSMutableArray alloc] init];
    }
}
- (void)settingAnimation {
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.baseView.transform = CGAffineTransformIdentity;
                     }];
}

- (IBAction)okCancelButton:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelButtonTapped:)]) {
        [self.delegate cancelButtonTapped:self.mode];
    }
}

- (IBAction)onOKButton:(id)sender {
        
    ModelManager *modelManager = [ModelManager sharedInstance];
    CGFloat red, green, blue, alpha;

    switch (self.mode) {
        case AlertModeColorPallet:
            // NSUserDefaultに色を保存する
            red = modelManager.blogSummaryModel.themeColorRed;
            green = modelManager.blogSummaryModel.themeColorGreen;
            blue = modelManager.blogSummaryModel.themeColorBlue;
            alpha = modelManager.blogSummaryModel.themeColorAlpha;
            
            [GeneralPurposeUtility saveUserDefault:[NSNumber numberWithFloat:red] key:THEMECOLOR_RED];
            [GeneralPurposeUtility saveUserDefault:[NSNumber numberWithFloat:green] key:THEMECOLOR_GREEN];
            [GeneralPurposeUtility saveUserDefault:[NSNumber numberWithFloat:blue] key:THEMECOLOR_BLUE];
            [GeneralPurposeUtility saveUserDefault:[NSNumber numberWithFloat:alpha] key:THEMECOLOR_ALPHA];            
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(okButtonTapped:)]) {
        [self.delegate okButtonTapped:self.mode];
    }
}


- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverCurrentContext;
}

@end
