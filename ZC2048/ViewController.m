//
//  ViewController.m
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "ViewController.h"
#import "GameViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 267, 63);
    [button setImage:[UIImage imageNamed:@"menu_play"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button {
    
    GameViewController *vc = [[GameViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}



@end
