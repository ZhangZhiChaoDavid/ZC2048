//
//  AppDelegate.h
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)float autoSizeScaleX;
@property(nonatomic,assign)float autoSizeScaleY;
+ (void)matchAllScreenWithView:(UIView *)allView;

@end

