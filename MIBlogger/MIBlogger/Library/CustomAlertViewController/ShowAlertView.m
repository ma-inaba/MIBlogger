//
//  ShowAlertView.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "ShowAlertView.h"

@implementation ShowAlertView

+ (CustomAlertViewController *)customAlertViewWithTitle:(NSString *)title
                                                message:(NSString *)message
                                               delegate:(id<CustomAlertViewControllerDelegate>)delegate
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                          okButtonTitle:(NSString *)okButtonTitle
                                                   mode:(AlertMode)mode {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:CustomAlertViewController_StoryboardID bundle:nil];
    // CustomAlertViewControllerを取得する
    CustomAlertViewController *alert = [storyboard instantiateViewControllerWithIdentifier:CustomAlertViewController_Identifier];
    alert.alertTitle = title;
    alert.alertMessage = message;
    alert.delegate = delegate;
    alert.cancelButtonTitle = cancelButtonTitle;
    alert.okButtonTitle = okButtonTitle;
    alert.mode = mode;
    
    return alert;
}


@end
