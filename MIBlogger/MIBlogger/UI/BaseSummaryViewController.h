//
//  BaseSummaryViewController.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSummaryViewController : UIViewController

- (void)longTapCell:(UILongPressGestureRecognizer *)gestureRecognizer;
- (void)createRefleshControl;
- (void)showCantOperationIndicator;
- (void)dismissCantOperationIndicator;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopLayout;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *effectView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIImageView *creannessImageView;


@end
