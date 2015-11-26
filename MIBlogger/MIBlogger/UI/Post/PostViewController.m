//
//  PostViewController.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/19.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PostViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postAction:(id)sender {

}

#pragma mark - UITableViewDelegate
// セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 44.0f;
    }

    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    float textCellHeight = self.view.frame.size.height - 88 - statusHeight - navigationBarHeight;
    return textCellHeight;
}

#pragma mark - UITableViewDatasouce
// セルの数を返す
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

// 指定されたインデックスパスのセルを作成する
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier;
    switch (indexPath.row) {
        case 0:
            cellIdentifier = @"TitleCell";
            break;
        case 1:
            cellIdentifier = @"OtherCell";
            break;
        case 2:
            cellIdentifier = @"TextCell";
            break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.contentView.backgroundColor = [GeneralPurposeUtility readThemeColorWithAlpha:0.7f];
            break;
        case 1:
            cell.contentView.backgroundColor = [GeneralPurposeUtility readThemeColorWithAlpha:0.5f];
            break;
        case 2:
            cell.contentView.backgroundColor = [GeneralPurposeUtility readThemeColorWithAlpha:0.2f];
//            cell.contentView.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:245.0f alpha:1.0f];
            break;
        default:
            break;
    }
    
    return cell;
}
@end
