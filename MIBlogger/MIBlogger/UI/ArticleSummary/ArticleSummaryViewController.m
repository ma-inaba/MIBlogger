//
//  ArticleSummaryViewController.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "ArticleSummaryViewController.h"
#import "PostViewController.h"
#import "ArticleViewController.h"
#import "UIImageView+WebCache.h"

typedef enum {
    CellTagFavoriteImageView = 1,
    CellTagTitleLabel,
    CellTagPublishedDateLabel,
    CellTagDisplayNameLabel,
    CellTagLabelsLabel,
    CellTagThumbnailImageView,
    CellTagTagImageView,
    CellTagLoadingImageIndicator,
    CellTagCommentLabel,
    CellTagReadNextArticleLabel
}CellTag;

@interface ArticleSummaryViewController ()
<
CustomAlertViewControllerDelegate
>
{
    ModelManager *modelManager;
}

- (IBAction)onBackButton:(id)sender;
- (IBAction)onArticleSortButton:(id)sender;
- (IBAction)onRefineButton:(id)sender;
- (IBAction)onPostButton:(id)sender;

@end

@implementation ArticleSummaryViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    modelManager = [ModelManager sharedInstance];
    modelManager.articleSummaryModel.blogArticleArray = nil;
    modelManager.articleSummaryModel.articleThumbnailArray = nil;
    modelManager.articleSummaryModel.nextPageToken = nil;
    
    [modelManager.articleSummaryModel requestArticleList];
    
    [self settingNavigationBar];
    
    [GeneralPurposeUtility readThemeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self settingData];
    [self settingObserver];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 登録が不要になったら解除
    [modelManager.articleSummaryModel removeObserver:self forKeyPath:@"blogArticleArray"];
    [modelManager.articleSummaryModel removeObserver:self forKeyPath:@"articleThumbnailArray"];
    [modelManager.articleSummaryModel removeObserver:self forKeyPath:@"nextPageToken"];
    [modelManager.articleSummaryModel removeObserver:self forKeyPath:@"allLabels"];
}
#pragma mark - Setting
- (void)settingData {
    
}
- (void)settingObserver {
    
    [modelManager.articleSummaryModel addObserver:self forKeyPath:@"blogArticleArray" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.articleSummaryModel addObserver:self forKeyPath:@"articleThumbnailArray" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.articleSummaryModel addObserver:self forKeyPath:@"nextPageToken" options:NSKeyValueObservingOptionNew context:nil];
    [modelManager.articleSummaryModel addObserver:self forKeyPath:@"allLabels" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)settingNavigationBar {
    
    // 次の記事画面のナビゲーションバーの文字を空にする
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    self.navigationItem.backBarButtonItem = backButton;
}

#pragma mark - UIGestureRecognizer
- (void)longTapCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        // UILongPressGestureRecognizerからlocationInView:を使ってタップした場所のCGPointを取得する
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        // 取得したCGPointを利用して、indexPathForRowAtPoint:でタップした場所のNSIndexPathを取得する
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        if (indexPath.row == [modelManager.articleSummaryModel.blogArticleArray count]) {
            // 次読み込みセルの場合は処理を行わない
            return;
        }
        
        [super longTapCell:gestureRecognizer];
    }
}

#pragma mark - Action
// 記事のお気に入り処理
- (void)hasBeenFavorite {

}

- (IBAction)onBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onArticleSortButton:(id)sender {
    
    CustomAlertViewController *alert = [ShowAlertView customAlertViewWithTitle:BlogSummary_Alert_SortArticleAlert_Title message:BlogSummary_Alert_SortArticleAlert_Message delegate:self cancelButtonTitle:Cancel okButtonTitle:Decision mode:AlertModeSortArticle];
    modelManager.generalPurposeModel.mode = AlertModeSortArticle;
    [self presentViewController:alert animated:NO completion: nil];
}

- (IBAction)onRefineButton:(id)sender {
    
    BOOL acquired = [[GeneralPurposeUtility readUserDefault:@"Acquired"] boolValue];
    if (!acquired) {
        [GeneralPurposeUtility showCancelOKButtonAlertControllerWithTitle:BlogSummary_Alert_RefineArticleConfirmationAlert_Title message:BlogSummary_Alert_RefineArticleConfirmationAlert_Message cancelButtonTitle:Non okButtonTitle:OK viewCon:self callback:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {  // はい
                // 取得処理
                [modelManager.articleSummaryModel requestLabelList];
                // アラート表示
                CustomAlertViewController *alert = [ShowAlertView customAlertViewWithTitle:BlogSummary_Alert_RefineArticleAlert_Title message:BlogSummary_Alert_RefineArticleAlert_Message delegate:self cancelButtonTitle:Cancel okButtonTitle:Decision mode:AlertModeRefineArticle];
                modelManager.generalPurposeModel.mode = AlertModeRefineArticle;
                [self presentViewController:alert animated:NO completion: nil];
            }
        }];
    } else {
        // 取得済みなのでユーザーデフォルトに保存してあるデータで表示を行う
        CustomAlertViewController *alert = [ShowAlertView customAlertViewWithTitle:BlogSummary_Alert_RefineArticleAlert_Title message:BlogSummary_Alert_RefineArticleAlert_Message delegate:self cancelButtonTitle:Cancel okButtonTitle:Decision mode:AlertModeRefineArticle];
        modelManager.generalPurposeModel.mode = AlertModeRefineArticle;
        [self presentViewController:alert animated:NO completion: nil];
    }
}

- (IBAction)onPostButton:(id)sender {
    
    // 投稿画面へ遷移
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PostViewController" bundle:nil];
    PostViewController *postViewController = [storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:postViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)onRefresh:(UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];
    
    [modelManager.articleSummaryModel requestArticleList];
    
    [refreshControl endRefreshing];
}

#pragma mark - KeyValueObserve
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual:@"blogArticleArray"]) {
        NSLog(@"%@",(NSArray *)[change objectForKey:@"new"]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];
            self.indicator = nil;
        });
    }
    
    if ([keyPath isEqual:@"articleThumbnailArray"]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];
            self.indicator = nil;
        });
    }
    
    if ([keyPath isEqual:@"nextPageToken"]) {

    }
    
    if ([keyPath isEqual:@"allLabels"]) {
        NSLog(@"%@",[GeneralPurposeUtility readUserDefault:@"AllLabels"]);        
    }
}
#pragma mark - CustomAlertViewControllerDelegate
- (void)cancelButtonTapped:(AlertMode)mode {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)okButtonTapped:(AlertMode)mode {
    
    switch (mode) {
        case AlertModeSortArticle:
            break;
        case AlertModeRefineArticle:
            NSLog(@"%@",modelManager.articleSummaryModel.selectedLabels);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITableViewDelegate
// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [modelManager.articleSummaryModel.blogArticleArray count]) {
        return 50.0f;
    }
    
    return 100.0f;
}
// セルが選択されたら呼ばれる
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
    if (indexPath.row == [modelManager.articleSummaryModel.blogArticleArray count]) {
        [modelManager.articleSummaryModel requestArticleListWithPageToken:modelManager.articleSummaryModel.nextPageToken];
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Article" bundle:nil];
        ArticleViewController *articleViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        modelManager.articleModel.url = [[modelManager.articleSummaryModel.blogArticleArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        [self.navigationController pushViewController:articleViewController animated:YES];
    }
}


#pragma mark - UITableViewDatasouce
// セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *nextPageToken = modelManager.articleSummaryModel.nextPageToken;
    if (nextPageToken != nil) {
        return [modelManager.articleSummaryModel.blogArticleArray count] + 1; //最後のセルには次読み込みボタンが入る
    }
    return [modelManager.articleSummaryModel.blogArticleArray count];
}

// 指定されたインデックスパスのセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([modelManager.articleSummaryModel.blogArticleArray count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    NSString *cellIdentifier = @"Cell";
    // 最後のセルなら次読み込みのセルを表示する
    if (indexPath.row == [modelManager.articleSummaryModel.blogArticleArray count]) {
        cellIdentifier = @"LastCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([cellIdentifier isEqualToString:@"Cell"]) {
        // 記事
        NSDictionary *article = [modelManager.articleSummaryModel.blogArticleArray objectAtIndex:indexPath.row];
        
        // 記事タイトル
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:CellTagTitleLabel];
        titleLabel.text = [article objectForKey:@"title"];
        
        // 投稿時間
        UILabel *publishedDateLabel = (UILabel *)[cell viewWithTag:CellTagPublishedDateLabel];
        NSString *rfc3336String = [article objectForKey:@"published"];
        NSDate *date = [GeneralPurposeUtility convertDateFromRFC3336:rfc3336String];
        NSString *dateString = [GeneralPurposeUtility convertStringFromDate:date];
        publishedDateLabel.text = dateString;
        
        // 投稿者
        UILabel *displayName = (UILabel *)[cell viewWithTag:CellTagDisplayNameLabel];
        displayName.text = [[article objectForKey:@"author"] objectForKey:@"displayName"];
        
        // ラベル
        UILabel *labelsLabel = (UILabel *)[cell viewWithTag:CellTagLabelsLabel];
        NSArray *labelArray = [article objectForKey:@"labels"];
        NSString *labels = [labelArray componentsJoinedByString:@" , "];
        labelsLabel.text = labels;
        
        // ラベルの画像
        UIImageView *tagImageView = (UIImageView *)[cell viewWithTag:CellTagTagImageView];
        tagImageView.image =[tagImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        tagImageView.tintColor = [GeneralPurposeUtility readThemeColor];
        
        // サムネイル
        UIImageView *thumbnailImageView = (UIImageView *)[cell viewWithTag:CellTagThumbnailImageView];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell viewWithTag:CellTagLoadingImageIndicator];
        indicator.color = [GeneralPurposeUtility readThemeColor];
        
        // 一回目の更新では画像が取得できていないので回避
        NSArray *articleThumbnailArray = modelManager.articleSummaryModel.articleThumbnailArray;
        if ([modelManager.articleSummaryModel.blogArticleArray count] == [articleThumbnailArray count]) {
            [indicator stopAnimating];
            NSURL *url = [NSURL URLWithString:[articleThumbnailArray objectAtIndex:indexPath.row]];

            if ([[articleThumbnailArray objectAtIndex:indexPath.row] isEqualToString:@""]) {
                thumbnailImageView.image = [UIImage imageNamed:@"NoImage"];
            } else {
                [thumbnailImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageCacheMemoryOnly];        
            }
        } else {
            // 以下判定でセルの再利用により前回の画像が表示されてしまう現象を回避 ついでにインジケータも
            if (indexPath.row >= [articleThumbnailArray count]) {
                thumbnailImageView.image = nil;
                [indicator startAnimating];
            }
        }
        
        // コメントラベル
        UILabel *commentLabel = (UILabel *)[cell viewWithTag:CellTagCommentLabel];
        commentLabel.text = [NSString stringWithFormat:@"コメント %@ 件",[[article objectForKey:@"replies"] objectForKey:@"totalItems"]];
    } else {
        // ラベル
//        UILabel *readNextLabel = (UILabel *)[cell viewWithTag:CellTagReadNextArticleLabel];
    }
    return cell;
}
@end
