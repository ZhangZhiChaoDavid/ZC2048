//
//  UIFactory.m
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.layer.cornerRadius = 5;
    return imageView ;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame title:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.5];
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    return label ;
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
