//
//  ShowAlertView.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomAlertViewController.h"

#define CustomAlertViewController_StoryboardID @"CustomAlertViewController"
#define CustomAlertViewController_Identifier @"CustomAlertViewController"

@interface ShowAlertView : NSObject

+ (CustomAlertViewController *)customAlertViewWithTitle:(NSString *)title
                                                message:(NSString *)message
                                               delegate:(id<CustomAlertViewControllerDelegate>)delegate
                                      cancelButtonTitle:(NSString *)cancelButtonTitle
                                          okButtonTitle:(NSString *)okButtonTitle
                                                   mode:(AlertMode)mode;

@end
