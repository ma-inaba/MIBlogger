//
//  GeneralPurposeUtility.h
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlertCallback)(NSInteger buttonIndex);

@interface GeneralPurposeUtility : NSObject

+ (void)showSimpleAlertControllerWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonTitle viewCon:(UIViewController *)viewCon callback:(AlertCallback)callback;
+ (void)showCancelOKButtonAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle viewCon:(UIViewController *)viewCon callback:(AlertCallback)callback;

+ (void)saveUserDefault:(id)obj key:(NSString *)key;
+ (id)readUserDefault:(NSString *)key;

+ (UIColor *)readThemeColor;
+ (UIColor *)readThemeColorWithAlpha:(float)alpha;


+ (NSDate *)convertDateFromRFC3336:(NSString *)rfc3336String;
+ (NSString *)convertStringFromDate:(NSDate *)date;

+ (void)addAutoLayoutFullScreen:(UIView *)view addALView:(UIView *)alView;
@end
