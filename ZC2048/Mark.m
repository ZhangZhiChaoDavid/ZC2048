//
//  Mark.m
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "Mark.h"

#define CHANCE 5


@interface Mark ()

@end

@implementation Mark

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.font = [UIFont boldSystemFontOfSize:30];
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        [self setRandomLuckyValue];
    }
    return self;
}

- (void)setRandomLuckyValue {
    
    NSInteger chance = arc4random()%CHANCE;
    _value = 2;
    if (chance == CHANCE-1) {
        _value = 4;
    }
    self.text = [self imageNameWithValue:_value];
    CGRect bounds = self.bounds;
    self.bounds = CGRectMake(0, 0, 0, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.bounds = bounds;
    }];
}

+ (UIColor *)colorForLevel:(NSInteger)level {
    
    switch (level) {
        case 1:
            return RGB(238, 228, 218);
        case 2:
            return RGB(237, 224, 200);
        case 3:
            return RGB(242, 177, 121);
        case 4:
            return RGB(245, 149, 99);
        case 5:
            return RGB(246, 124, 95);
        case 6:
            return RGB(246, 94, 59);
        case 7:
            return RGB(237, 207, 114);
        case 8:
            return RGB(237, 204, 97);
        case 9:
            return RGB(237, 200, 80);
        case 10:
            return RGB(237, 197, 63);
        case 11:
            return RGB(237, 194, 46);
        case 12:
            return RGB(173, 183, 119);
        case 13:
            return RGB(170, 183, 102);
        case 14:
            return RGB(164, 183, 79);
        case 15:
        default:
            return RGB(161, 183, 63);
    }
}


+ (UIColor *)textColorForLevel:(NSInteger)level {
    
    switch (level) {
        case 1:
        case 2:
            return RGB(118, 109, 100);
        default:
            return [UIColor whiteColor];
    }
}

- (NSString *)imageNameWithValue:(NSInteger)value {
    
    int i;
    for (i=1; i<32; i++) {
        if (value & 1<<i) {
            break;
        }
    }
    self.backgroundColor = [Mark colorForLevel:i];
    self.textColor = [Mark textColorForLevel:i];
    return [NSString stringWithFormat:@"%ld",(long)value];
}

- (void)setValue:(NSInteger)value {
    
    _value = value;
    self.text = [self imageNameWithValue:value];
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

- (BOOL)valueCompare:(Mark *)iv {
    
    return self.value < iv.value;
}


@end
