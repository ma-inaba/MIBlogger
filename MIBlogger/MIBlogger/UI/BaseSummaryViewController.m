//
//  BaseSummaryViewController.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "BaseSummaryViewController.h"

@interface BaseSummaryViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@end

@implementation BaseSummaryViewController
{
    UIWindow *window;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingView];
    [self settingGesture];
    [self createIndicator];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self createRefleshControl];
}

#pragma mark - Setting
- (void)settingView {
    self.effectView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:kDefaultEffectViewAlphaLevel];
    self.backView.backgroundColor = [GeneralPurposeUtility readThemeColor];
    
    self.creannessImageView.image =[self.creannessImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.creannessImageView.tintColor = self.tableView.backgroundColor;
}

- (void)settingGesture {
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapCell:)];
    longPressRecognizer.allowableMovement = 15;
    longPressRecognizer.minimumPressDuration = 0.6f;
    [self.tableView addGestureRecognizer: longPressRecognizer];
}

#pragma mark - UIGestureRecognizer
- (void)longTapCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil){
        return;
    } else if (((UILongPressGestureRecognizer *)gestureRecognizer).state == UIGestureRecognizerStateBegan){
        [GeneralPurposeUtility showCancelOKButtonAlertControllerWithTitle:BlogSummary_Alert_FavoriteAlert_Title message:BlogSummary_Alert_FavoriteAlert_Message cancelButtonTitle:Non okButtonTitle:OK viewCon:self callback:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {  // はい
                [self hasBeenFavorite];
            }
        }];
    }
}

#pragma mark - Action
// 記事のお気に入り処理
- (void)hasBeenFavorite {
    // 子が継承
}

- (void)createIndicator {
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.color = [GeneralPurposeUtility readThemeColor];
    self.indicator.center = self.view.center;
    self.indicator.hidesWhenStopped = YES;
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)createRefleshControl {
    if (self.refreshControl) {
        [self.refreshControl removeFromSuperview];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(onRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.refreshControl.tintColor = [GeneralPurposeUtility readThemeColor];
}

- (void)onRefresh:(UIRefreshControl *)refreshControl {
    
}

- (void)showCantOperationIndicator {
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.color = [GeneralPurposeUtility readThemeColor];
    self.indicator.center = self.view.center;
    self.indicator.hidesWhenStopped = YES;
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor lightGrayColor];
    window.alpha = 0.5f;
    [window addSubview:self.indicator];
    [self.indicator startAnimating];
    
    [self.view layoutIfNeeded];
}
- (void)dismissCantOperationIndicator {
    
    [window removeFromSuperview];
}


#pragma mark - UIScrollViewDelegate
// スクロール中に呼ばれる
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 上にスクロールさせた場合
    if (scrollView.contentOffset.y > 0) {
        // 一番上までスクロールさせた場合
        if (self.headerView.frame.origin.y < 0) {
            CGRect frame = self.tableView.frame;
            frame.origin.y = CGPointZero.y;
        } else {
            self.tableViewTopLayout.constant -= scrollView.contentOffset.y;
            self.tableView.contentOffset = CGPointMake(0, -self.tableView.contentInset.top);
            // ヘッダー部分の透明度変更
            float alpha = 1 - (self.tableViewTopLayout.constant/ kDefaultTableViewTopLayout) + kDefaultEffectViewAlphaLevel;
            self.effectView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:alpha];
        }
    }
    
    // 下にスクロールさせた場合
    if (scrollView.contentOffset.y < 0) {
        // 規定のconstant以上になった場合は規定のconstantに戻す
        if (self.tableViewTopLayout.constant >= kDefaultTableViewTopLayout) {
            self.tableViewTopLayout.constant = kDefaultTableViewTopLayout;
        } else {
            self.tableViewTopLayout.constant += fabs(scrollView.contentOffset.y);
            // ヘッダー部分の透明度変更
            float alpha = 1 - (self.tableViewTopLayout.constant/ kDefaultTableViewTopLayout) + kDefaultEffectViewAlphaLevel;
            self.effectView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:alpha];
        }
    }
}

#pragma mark - UITableViewDelegate
// 横スワイプの削除ボタンを生成する
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"お気に入り" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        [self hasBeenFavorite];
                                        [self.tableView endUpdates];
                                        [self.tableView setEditing:NO animated:YES];
                                    }];
    button.backgroundColor = [GeneralPurposeUtility readThemeColor];
    
    // TODO: ボタンを追加したい場合はここで上記のように生成する
    return @[button];
}

#pragma mark - UITableViewDatasouce
// セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

// 指定されたインデックスパスのセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
// TODO: 横スワイプがこのメソッドがないと動かない。要調査
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 編集を許可する
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
