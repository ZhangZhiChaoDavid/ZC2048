//
//  Mark.h
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mark : UILabel

@property (nonatomic, assign) BOOL isMerge;
@property (nonatomic, assign) BOOL isMove;
@property (nonatomic, assign) NSInteger value;

- (void)setRandomLuckyValue;
- (BOOL)valueCompare:(Mark *)iv;

@end
