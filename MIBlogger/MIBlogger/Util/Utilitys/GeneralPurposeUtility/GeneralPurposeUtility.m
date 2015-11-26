//
//  GeneralPurposeUtility.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/04.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "GeneralPurposeUtility.h"

@implementation GeneralPurposeUtility

+ (void)showSimpleAlertControllerWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonTitle viewCon:(UIViewController *)viewCon callback:(AlertCallback)callback {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (callback) {
            callback(0);
        }
    }]];
    [viewCon presentViewController:alertController animated:YES completion:nil];
}

+ (void)showCancelOKButtonAlertControllerWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle viewCon:(UIViewController *)viewCon callback:(AlertCallback)callback{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (callback) {
            callback(0);
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (callback) {
            callback(1);
        }
    }]];

    [viewCon presentViewController:alertController animated:YES completion:nil];
}

+ (void)saveUserDefault:(id)obj key:(NSString *)key {
    
    // NSUserDefaultsに保存・更新する
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    [ud setObject:obj forKey:key];
    [ud synchronize];  // NSUserDefaultsに即時反映させる
}

+ (id)readUserDefault:(NSString *)key {
    
    // NSUserDefaultsからデータを読み込む
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];  // 取得
    return [ud objectForKey:key];
}

+ (UIColor *)readThemeColor {
    
    CGFloat red, green, blue, alpha;
    red = [[GeneralPurposeUtility readUserDefault:THEMECOLOR_RED] floatValue];
    green = [[GeneralPurposeUtility readUserDefault:THEMECOLOR_GREEN] floatValue];
    blue = [[GeneralPurposeUtility readUserDefault:THEMECOLOR_BLUE] floatValue];
    alpha = [[GeneralPurposeUtility readUserDefault:THEMECOLOR_ALPHA] floatValue];
    
    // 登録されていないのであれば
    if (red == 0 && green == 0 && blue == 0 && alpha == 0) {
        return [UIColor colorWithRed:1 green:0.59153217077255249 blue:0.2235621239129639 alpha:1];
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (UIColor *)readThemeColorWithAlpha:(float)alpha {
    
    UIColor *color = [self readThemeColor];
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    return color;
}



+ (NSDate *)convertDateFromRFC3336:(NSString *)rfc3336String {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'";
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    //最後の+09:00の削除
    long length = [rfc3336String length];
    NSString *string = [rfc3336String substringToIndex:(length-6)];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

+ (NSString *)convertStringFromDate:(NSDate *)date {
    date = [date initWithTimeInterval:-9*60*60 sinceDate:date]; // 9時間後
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    // ここの時点では正常
    [outputFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [outputFormatter stringFromDate:date];
    // ここで９時間あとになる
    
    return dateString;
}

+ (void)addAutoLayoutFullScreen:(UIView *)view addALView:(UIView *)alView {
    
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:alView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:alView
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:alView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:0],
                                
                                [NSLayoutConstraint constraintWithItem:alView
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:0],
                                
                                ]];
}
@end
