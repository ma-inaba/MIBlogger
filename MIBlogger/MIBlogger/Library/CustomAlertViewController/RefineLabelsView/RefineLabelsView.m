//
//  RefineLabelsView.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/08/01.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "RefineLabelsView.h"
#import "RefineLabelsViewCell.h"

#define kDefaultCellHeight 44.0f

@implementation RefineLabelsView
{
    NSArray *labelArray;
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
    UINib *nib = [UINib nibWithNibName:@"RefineLabelsViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    labelArray = [GeneralPurposeUtility readUserDefault:@"AllLabels"];
    self.collectionView.allowsMultipleSelection = YES;
}

+ (instancetype)refineLabelsView {
    
    // xib ファイルから SortView のインスタンスを得る
    UINib *nib = [UINib nibWithNibName:@"RefineLabelsView" bundle:nil];
    RefineLabelsView *refineLabelsView = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    
    return refineLabelsView;
}

+ (CGFloat)refineLabelsViewHeight {
    
    return 150;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ModelManager *modelManager = [ModelManager sharedInstance];
    // 選択した文字列と同じものが入っていたら削除、入っていなかったら追加
    NSUInteger index = [modelManager.articleSummaryModel.selectedLabels indexOfObject:[labelArray objectAtIndex:indexPath.row]];
    if (index != NSNotFound) {
        [modelManager.articleSummaryModel.selectedLabels removeObjectAtIndex:index];
    } else {
        [modelManager.articleSummaryModel.selectedLabels addObject:[labelArray objectAtIndex:indexPath.row]];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [(NSString*)[labelArray objectAtIndex:indexPath.row] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    // 文字サイズプラス余白を設定
    size.width = size.width + 20+20;   // 文字サイズ+20の余白+左の画像のサイズ
    size.height = size.height + 10;
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return labelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // セルオブジェクトを得る
    RefineLabelsViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:CellTagLabel];
    label.text = [labelArray objectAtIndex:indexPath.row];
    
    UIView *selectedView = [UIView new];
    selectedView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.8 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}
@end
