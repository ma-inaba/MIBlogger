//
//  SortView.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/11.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "SortView.h"
#import "SortViewCell.h"

#define kDefaultCellHeight 44.0f

@implementation SortView
{
    NSArray *titleArray;
    NSMutableArray *selectStateArray;
}

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
    // カスタマイズしたセルをテーブルビューにセット
    UINib *nib = [UINib nibWithNibName:@"SortViewCell" bundle:nil];
    [self.sortTableView registerNib:nib forCellReuseIdentifier:@"SortViewCell"];
    
    titleArray = [self createArray];
    selectStateArray = [[NSMutableArray alloc] init];
    
    // 選択状態配列に全てNOを入れる
    BOOL selected = NO;
    for (int i = 0; i < [titleArray count]; i++) {
        [selectStateArray addObject:[NSNumber numberWithBool:selected]];
    }
    
    self.sortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

+ (instancetype)sortView {
    
    // xib ファイルから SortView のインスタンスを得る
    UINib *nib = [UINib nibWithNibName:@"SortView" bundle:nil];
    SortView *sortView = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    return sortView;
}

+ (CGFloat)sortViewHeight {
    ModelManager *modelManager = [ModelManager sharedInstance];
    AlertMode mode = modelManager.generalPurposeModel.mode;
    NSArray *array;
    if (mode == AlertModeSortBlog) {
        array = modelManager.blogSummaryModel.blogSortTitleArray;
    } else if (mode == AlertModeSortArticle) {
        array = modelManager.articleSummaryModel.articleSortTitleArray;
    }

    return [array count] * kDefaultCellHeight;
}

- (NSArray *)createArray {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    AlertMode mode = modelManager.generalPurposeModel.mode;
    NSArray *array;
    if (mode == AlertModeSortBlog) {
        array = modelManager.blogSummaryModel.blogSortTitleArray;
    } else if (mode == AlertModeSortArticle) {
        array = modelManager.articleSummaryModel.articleSortTitleArray;
    }
    
    return array;
}

#pragma mark - UITableViewDelegate
// セルが選択されたら呼ばれる
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択状態の解除
    // 選択状態の反転
    BOOL selected = [[selectStateArray objectAtIndex:indexPath.row] boolValue];
    [selectStateArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!selected]];
    [self.sortTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDatasouce
// セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = [self createArray];
    return [array count];
}

// 指定されたインデックスパスのセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"SortViewCell";
    SortViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SortViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:CellTagTitleLabel];
    NSString *titleText = [titleArray objectAtIndex:indexPath.row];
    label.text = titleText;

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:CellTagCheckBox];
    imageView.image =[imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [GeneralPurposeUtility readThemeColor];
    BOOL selected = [[selectStateArray objectAtIndex:indexPath.row] boolValue];
    imageView.hidden = !selected;
    
    
    return cell;
}
@end
