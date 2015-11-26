//
//  BlogSummaryViewController.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/03.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "BlogSummaryViewController.h"
#import "ArticleSummaryViewController.h"

typedef enum {
    CellTagFavoriteImageView = 1,
    CellTagTitleLabel,
    CellTagDescriptionLabel
}CellTag;

@interface BlogSummaryViewController ()
<
CustomAlertViewControllerDelegate
>
{
    NSDictionary *myBlogsDict;
}

- (IBAction)onThemebutton:(id)sender;
- (IBAction)onBlogSortButton:(id)sender;
- (IBAction)onLogoutButton:(id)sender;

@end

@implementation BlogSummaryViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UINib *nib = [UINib nibWithNibName:@"LaunchScreen" bundle:nil];
        UIView *launchScreen = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        
        [self.view addSubview:launchScreen];
        [launchScreen setTranslatesAutoresizingMaskIntoConstraints:NO];
        [GeneralPurposeUtility addAutoLayoutFullScreen:self.view addALView:launchScreen];
        
        [UIView animateWithDuration:0.8f
                              delay:1.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             launchScreen.transform = CGAffineTransformMakeScale(80.0, 80.0);
                             launchScreen.alpha = 0;
                         } completion:^(BOOL finished) {
                             [launchScreen removeFromSuperview];
                         }];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self settingObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 登録が不要になったら解除
    ModelManager *modelManager = [ModelManager sharedInstance];
    [modelManager.blogSummaryModel removeObserver:self forKeyPath:@"themeColor"];
    [modelManager.blogSummaryModel removeObserver:self forKeyPath:@"oAuth2ViewCon"];
    [modelManager.blogSummaryModel removeObserver:self forKeyPath:@"auth"];
    [modelManager.blogSummaryModel removeObserver:self forKeyPath:@"myBlogsDict"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self startLogin];
}

#pragma mark - Setting
- (void)settingObserver {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    [modelManager.blogSummaryModel addObserver:self forKeyPath:@"themeColor" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.blogSummaryModel addObserver:self forKeyPath:@"oAuth2ViewCon" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.blogSummaryModel addObserver:self forKeyPath:@"auth" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.blogSummaryModel addObserver:self forKeyPath:@"myBlogsDict" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Action
- (void)startLogin {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    [modelManager.blogSummaryModel startLogin:NO];
}
// 記事のお気に入り処理
- (void)hasBeenFavorite {
    
    // TODO: オーバーライド
}

- (IBAction)onThemebutton:(id)sender {
    
    CustomAlertViewController *alert = [ShowAlertView customAlertViewWithTitle:BlogSummary_Alert_ColorPalletAlert_Title message:BlogSummary_Alert_ColorPalletAlert_Message delegate:self cancelButtonTitle:Cancel okButtonTitle:Decision mode:AlertModeColorPallet];
    ModelManager *modelManager = [ModelManager sharedInstance];
    modelManager.generalPurposeModel.mode = AlertModeColorPallet;
    [self presentViewController:alert animated:NO completion: nil];
}

- (IBAction)onBlogSortButton:(id)sender {
    
    CustomAlertViewController *alert = [ShowAlertView customAlertViewWithTitle:BlogSummary_Alert_SortBlogAlert_Title message:BlogSummary_Alert_SortBlogAlert_Message delegate:self cancelButtonTitle:Cancel okButtonTitle:Decision mode:AlertModeSortBlog];
    ModelManager *modelManager = [ModelManager sharedInstance];
    modelManager.generalPurposeModel.mode = AlertModeSortBlog;
    [self presentViewController:alert animated:NO completion: nil];
}

- (IBAction)onLogoutButton:(id)sender {

    [GeneralPurposeUtility showCancelOKButtonAlertControllerWithTitle:BlogSummary_Alert_LogoutAlert_Title message:BlogSummary_Alert_LogoutAlert_Message cancelButtonTitle:Non okButtonTitle:OK viewCon:self callback:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {  // はい
            ModelManager *modelManager = [ModelManager sharedInstance];
            [modelManager.blogSummaryModel startLogin:YES];
        }
    }];
}

- (void)onRefresh:(UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    [modelManager.blogSummaryModel requestBlogList];
    
    [refreshControl endRefreshing];
}

#pragma mark - KeyValueObserve
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"themeColor"]) {
        UIColor *themeColor = (UIColor *)[change objectForKey:@"new"];

        // 背景色とボタンの色を変更する
        self.backView.backgroundColor = themeColor;
        NSArray *subViews = [self.headerView subviews];
        for (int i = 0; i < [subViews count]; i++) {
            if ([[subViews objectAtIndex:i] isKindOfClass:[MIDefaultButton class]]) {
                MIDefaultButton *button = [subViews objectAtIndex:i];
                [button.layer setBorderColor:themeColor.CGColor];
                [button setTitleColor:themeColor forState:UIControlStateNormal];
            }
        }
    }
    
    if ([keyPath isEqual:@"oAuth2ViewCon"]) {
        GTMOAuth2ViewControllerTouch *oAuth2ViewCon = (GTMOAuth2ViewControllerTouch *)[change objectForKey:@"new"];
        [self presentViewController:oAuth2ViewCon animated:YES completion:nil];
    }
    
    if ([keyPath isEqual:@"auth"]) {
        ModelManager *modelManager = [ModelManager sharedInstance];
        [modelManager.blogSummaryModel requestBlogList];
    }
    
    if ([keyPath isEqual:@"myBlogsDict"]) {
        myBlogsDict = (NSDictionary *)[change objectForKey:@"new"];
        NSLog(@"%@",myBlogsDict);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];
            self.indicator = nil;
        });
    }
}

#pragma mark - CustomAlertViewControllerDelegate
- (void)cancelButtonTapped:(AlertMode)mode {
    UIColor *themeColor = [GeneralPurposeUtility readThemeColor];

    self.backView.backgroundColor = themeColor;
    NSArray *subViews = [self.headerView subviews];
    for (int i = 0; i < [subViews count]; i++) {
        if ([[subViews objectAtIndex:i] isKindOfClass:[MIDefaultButton class]]) {
            MIDefaultButton *button = [subViews objectAtIndex:i];
            [button.layer setBorderColor:themeColor.CGColor];
            [button setTitleColor:themeColor forState:UIControlStateNormal];
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)okButtonTapped:(AlertMode)mode {
    
    switch (mode) {
        case AlertModeColorPallet:
            // RefleshControlの色も変更する
            [self createRefleshControl];
            // ナビゲーションバーの色
            [UINavigationBar appearance].barTintColor = [GeneralPurposeUtility readThemeColor];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDelegate

// セルが選択されたら呼ばれる
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    modelManager.articleSummaryModel.selectedBlogDict = [[myBlogsDict objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ArticleSummary" bundle:nil];
    ArticleSummaryViewController *articleSummaryViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArticleSummaryViewController"];
    [self.navigationController pushViewController:articleSummaryViewController animated:YES];
}


#pragma mark - UITableViewDatasouce
// セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [[myBlogsDict objectForKey:@"items"] count];
}

// 指定されたインデックスパスのセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *blog = [[myBlogsDict objectForKey:@"items"] objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTagTitleLabel];
    titleLabel.text = [blog objectForKey:@"name"];
    
    UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:CellTagDescriptionLabel];
    descriptionLabel.text = [blog objectForKey:@"description"];

    return cell;
}
@end
