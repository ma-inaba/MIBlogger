//
//  CustomAlertViewController.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    AlertModeColorPallet,
    AlertModeSortBlog,
    AlertModeSortArticle,
    AlertModeRefineArticle
}AlertMode;

@protocol CustomAlertViewControllerDelegate <NSObject>

- (void)cancelButtonTapped:(AlertMode)mode;
- (void)okButtonTapped:(AlertMode)mode;
@end

@interface CustomAlertViewController : UIViewController

@property (nonatomic, assign) id<CustomAlertViewControllerDelegate>delegate;
@property (nonatomic, retain) NSString *alertTitle;
@property (nonatomic, retain) NSString *alertMessage;
@property (nonatomic, retain) NSString *cancelButtonTitle;
@property (nonatomic, retain) NSString *okButtonTitle;
@property AlertMode mode;


@end
