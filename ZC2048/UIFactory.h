//
//  UIFactory.h
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIFactory : NSObject

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title;

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

@end
