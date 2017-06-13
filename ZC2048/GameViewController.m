//
//  GameViewController.m
//  ZC2048
//
//  Created by 张智超 on 2016/4/12.
//  Copyright © 2016年 GeezerChao. All rights reserved.
//

#import "GameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIFactory.h"
#import "Mark.h"

@interface GameViewController (){
    
    UILabel *_scoreLabel;
    NSInteger _count;
    UILabel *_addScoreLabel;
    UILabel *_highLabel;
    SystemSoundID _moveSoundID;
    SystemSoundID _mergeSoundID;
    BOOL _isPlaySound;
    UIImageView *_gameView;
    NSMutableArray *_platformArray;
    NSMutableArray *_luckyArray;
    NSMutableArray *_refuseLuckyArray;
    NSInteger _xDirection;
    NSInteger _yDirection;
    NSInteger _startRow;
    NSInteger _startColumn;
    BOOL _canCreateLucky;
    
    SystemSoundID _daddySoundID;
    
    BOOL isLock;
}


@end

@implementation GameViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createStartedLucky];
    [self createSwipeGestureRecognizer];
}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconView = [UIFactory createImageViewWithFrame:CGRectMake(10, 30, 100, 100) imageName:@"icon"];
    [self.view addSubview:iconView];
    
    UIImageView *scoreImageView = [UIFactory createImageViewWithFrame:CGRectMake(120, 30, 90, 60) imageName:@"board_score"];
    _scoreLabel = [UIFactory createLabelWithFrame:CGRectMake(5, 30, 80, 30) title:@"0"];
    [scoreImageView addSubview:_scoreLabel];
    
    _addScoreLabel = [UIFactory createLabelWithFrame:CGRectMake(5, 30, 80, 30) title:@""];
    _addScoreLabel.hidden = YES;
    [scoreImageView addSubview:_addScoreLabel];
    [self.view addSubview:scoreImageView];
    
    UIImageView *highImageView = [UIFactory createImageViewWithFrame:CGRectMake(220, 30, 90, 60) imageName:@"board_best"];
    NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"];
    if (title == nil) {
        title = @"0";
    }
    _highLabel = [UIFactory createLabelWithFrame:CGRectMake(5, 30, 80, 30) title:title];
    [highImageView addSubview:_highLabel];
    [self.view addSubview:highImageView];
    
    UIButton *quitButton = [UIFactory createButtonWithFrame:CGRectMake(120, 100, 90, 30) title:@"退出游戏" target:self action:@selector(quitButtonClick:)];
    [self.view addSubview:quitButton];
    
    UIButton *soundButton = [UIFactory createButtonWithFrame:CGRectMake(220, 100, 90, 30) title:@"停止声音" target:self action:@selector(soundButtonClick:)];
    [self.view addSubview:soundButton];
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"move" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(fileURL), &_moveSoundID);
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"merge" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(fileURL), &_mergeSoundID);
    
    _isPlaySound = YES;
    
    _gameView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 300, 300)];
    _gameView.image = [UIImage imageNamed:@"tile_board"];
    [self.view addSubview:_gameView];
    
    _platformArray = [[NSMutableArray alloc] init];
    
    CGFloat space = 1.0*300/580*20;
    CGFloat width = 1.0*300/580*120;
    for (int i=0; i<4; i++) {
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithCapacity:4];
        for (int j=0; j<4; j++) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(space+j*(width+space), 10+i*(width+space), width, width)];
            iv.tag = j+i*10;
            [_gameView addSubview:iv];
            [rowArray addObject:iv];
        }
        [_platformArray addObject:rowArray];
    }
    
    fileURL = [[NSBundle mainBundle] URLForResource:@"cat" withExtension:@"wav"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(fileURL), &_daddySoundID);
    
    [AppDelegate matchAllScreenWithView:self.view];
}

- (void)quitButtonClick:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)soundButtonClick:(UIButton *)button {
    
    if (_isPlaySound) {
        [button setTitle:@"开始声音" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"停止声音" forState:UIControlStateNormal];
    }
    _isPlaySound = !_isPlaySound;
}

- (void)createRandomLucky {
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (UIImageView *platform in _gameView.subviews) {
        if (platform.subviews.count == 0) {
            [tmpArray addObject:platform];
        }
    }
    
    if (tmpArray.count) {
        NSInteger index = arc4random()%tmpArray.count;
        UIImageView *platform = (UIImageView *)[tmpArray objectAtIndex:index];
        Mark *liv = [self dequenceRefuseLuckyImageView];
        if (liv == nil) {
            liv = [[Mark alloc] initWithFrame:CGRectMake(0, 0, platform.bounds.size.width, platform.bounds.size.height)];
            [platform addSubview:liv];
            [_luckyArray addObject:liv];
        } else {
            [liv setRandomLuckyValue];
            [_luckyArray addObject:liv];
            [platform addSubview:liv];
        }
    }
}

- (Mark *)dequenceRefuseLuckyImageView {
    
    Mark *liv = nil;
    if (_refuseLuckyArray.count) {
        liv = [_refuseLuckyArray firstObject] ;
        [_refuseLuckyArray removeObjectAtIndex:0];
    }
    return liv ;
}

- (void)createStartedLucky {
    
    _luckyArray = [[NSMutableArray alloc] init];
    _refuseLuckyArray = [[NSMutableArray alloc] init];
    NSInteger num = 2;
    while (num--) {
        [self createRandomLucky];
    }
}

- (void)createSwipeGestureRecognizer {
    
    UISwipeGestureRecognizerDirection direction[4] = {
        UISwipeGestureRecognizerDirectionRight,
        UISwipeGestureRecognizerDirectionLeft,
        UISwipeGestureRecognizerDirectionUp,
        UISwipeGestureRecognizerDirectionDown
    };
    
    for (NSUInteger i=0; i<4; i++) {
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandle:)];
        swipe.direction = direction[i];
        [self.view addGestureRecognizer:swipe];
    }
}

- (void)swipeHandle:(UISwipeGestureRecognizer *)swipe {
    
    if (_isPlaySound == YES) {
        AudioServicesPlaySystemSound(_moveSoundID);
    }
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionUp:
            _xDirection = -1;
            _yDirection = 0;
            _startRow = 0;
            _startColumn = 0;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            _xDirection = 1;
            _yDirection = 0;
            _startRow = 3;
            _startColumn = 0;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            _xDirection = 0;
            _yDirection = -1;
            _startRow = 0;
            _startColumn = 0;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            _xDirection = 0;
            _yDirection = 1;
            _startRow = 0;
            _startColumn = 3;
            break;
        default:
            break;
    }
    
    [self move];
    
    for (Mark *liv in _luckyArray) {
        liv.isMerge = NO;
    }
    
    if (_canCreateLucky) {
        [self createRandomLucky];
        _canCreateLucky = NO;
    }
    
    if (_count) {
        _addScoreLabel.text = [NSString stringWithFormat:@"+%ld",(long)_count];
        _addScoreLabel.hidden = NO;
        CGRect frame = _addScoreLabel.frame;
        [UIView animateWithDuration:0.5 animations:^{
            _addScoreLabel.frame = CGRectMake(frame.origin.x, frame.origin.y-25, frame.size.width, frame.size.height);
        } completion:^(BOOL finished) {
            _addScoreLabel.hidden = YES;
            _addScoreLabel.frame = frame;
            NSInteger sum = [_scoreLabel.text integerValue];
            sum += _count;
            NSString *scoreString = [NSString stringWithFormat:@"%ld",(long)sum];
            _scoreLabel.text = scoreString;
            
            NSInteger highScore = [_highLabel.text integerValue];
            if (sum > highScore) {
                _highLabel.text = scoreString;
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:scoreString forKey:@"HighScore"];
                [ud synchronize];
            }
            _count = 0;
        }];
    }
}

- (void)move {
    
    NSInteger xIncrement = _startRow?-1:1;
    NSInteger yIncrement = _startColumn?-1:1;
    for (NSInteger i=_startRow; i<4&&i>=0; i+=xIncrement) {
        for (NSInteger j=_startColumn; j<4&&j>=0; j+=yIncrement) {
            UIImageView *srcPlatform = (UIImageView *)_platformArray[i][j];
            
            if (srcPlatform.subviews.count) {
                [self moveLucky:srcPlatform.subviews.lastObject row:i+_xDirection column:j+_yDirection];
            }
        }
    }
}

- (void)moveLucky:(Mark *)lucky row:(NSInteger)row column:(NSInteger)column {
    
    if (row<0 || column<0 || row >3 || column>3) {
        return;
    }
    UIImageView *platform = (UIImageView *)_platformArray[row][column];
    Mark *liv = nil;
    if (platform.subviews.count) {
        liv = platform.subviews.lastObject;
    }
    
    if (liv && liv.isMerge == YES) {
        return;
    }
    
    if (liv && (liv.value != lucky.value)) {
        return;
    }
    
    _canCreateLucky = YES;
    
    if (liv) {
        
        if (_isPlaySound) {
            AudioServicesPlaySystemSound(_mergeSoundID);
        }
        [_refuseLuckyArray addObject:liv];
        [liv removeFromSuperview];
        [_luckyArray removeObject:liv];
        lucky.value = lucky.value*2;
        
        _count += lucky.value;
        lucky.isMerge = YES;
        [lucky removeFromSuperview];
        [platform addSubview:lucky];
    } else {
        [lucky removeFromSuperview];
        [platform addSubview:lucky];
        [self moveLucky:lucky row:row+_xDirection column:column+_yDirection];
    }
}



@end
