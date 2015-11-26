//
//  AppDelegate.m
//  MIBlogger
//
//  Created by inaba masaya on 2015/07/03.
//  Copyright (c) 2015年 inaba masaya. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // ナビゲーションバーの中身の色
    [UINavigationBar appearance].tintColor = [UIColor colorWithRed:255.0f green:255.0f blue:245.0f alpha:1.0f];
    // ナビゲーションバーのタイトルの色
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:255.0f green:255.0f blue:245.0f alpha:1.0f]};
    // ナビゲーションバーの色
    [UINavigationBar appearance].barTintColor = [GeneralPurposeUtility readThemeColor];
    
    // ステータスバー文字色白
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (BOOL)isFirstRun
//{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    if ([userDefaults objectForKey:@"firstRunDate"]) {
//        // 日時が設定済みなら初回起動でない
//        return NO;
//    }
//    
//    // 初回起動日時を設定
//    [userDefaults setObject:[NSDate date] forKey:@"firstRunDate"];
//    
//    // 保存
//    [userDefaults synchronize];
//    
//    // 初回起動
//    return YES;
//}

@end
