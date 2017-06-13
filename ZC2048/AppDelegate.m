//
//  AppDelegate.m
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (Main_Screen_Height == 667 || Main_Screen_Height == 736) {
        self.autoSizeScaleX = Main_Screen_Width/320.0;
        self.autoSizeScaleY = Main_Screen_Height/568.0;
    }
    else if (Main_Screen_Height == 568){
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)matchAllScreenWithView:(UIView *)allView {
    
    for (UIView *tmpView in allView.subviews) {
        tmpView.frame = CGRectMake1(tmpView.frame.origin.x, tmpView.frame.origin.y, tmpView.frame.size.width, tmpView.frame.size.height);
        [self matchAllScreenWithView:tmpView];
    }
}
CG_INLINE CGRect
CGRectMake1(CGFloat x,CGFloat y,CGFloat width,CGFloat height) {
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX;
    rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    
    return rect;
}

@end
