//
//  TutorialVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/14.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "TutorialVC.h"

@interface TutorialVC ()
{
    UIVisualEffectView  *_mainV;
    UIButton            *_testBtn;
    UIScrollView        *_topSV;
    UIScrollView        *_bottomSV;
}
@end

@implementation TutorialVC


- (void) setupUI {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setOpaque:false];
    
    UIBlurEffect *blurEff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _mainV = [[UIVisualEffectView alloc] initWithEffect:blurEff];
    _mainV.frame = self.view.frame;
    [self.view addSubview:_mainV];
    
    _testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [_testBtn addTarget:self action:@selector(didPressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_testBtn setTintColor:[UIColor blueColor]];
    [_testBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_testBtn setTitle:@"TEST" forState:UIControlStateNormal];
    [self.view addSubview:_testBtn];
    
    ////////////////////////////////////
    //          SCROLLVIEW
    ////////////////////////////////////
    _topSV = [UIScrollView new];
    _bottomSV = [UIScrollView new];
    
    _topSV.translatesAutoresizingMaskIntoConstraints = false;
    _bottomSV.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:_topSV];
    [self.view addSubview:_bottomSV];
    
    ////////////////////////////////////
    //          Constraints
    ////////////////////////////////////
    
}

#pragma mark - LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ACTIONS
- (void)didPressedBtn:(UIButton *) sender {
    if (_delegate) {
        [_delegate didPressedBtn];
    }
}

@end
