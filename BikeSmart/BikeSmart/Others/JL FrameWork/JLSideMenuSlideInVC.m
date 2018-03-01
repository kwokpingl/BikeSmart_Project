//
//  JLSideMenuSlideInVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/27.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "JLSideMenuSlideInVC.h"

static CGFloat sideBarViewWidth = 100;

@interface JLSideMenuSlideInVC ()
@property (nonatomic) UIView                        *containerView;
@property (nonatomic) UIView                        *sideBarView;
@property (nonatomic, getter=isSideBarOpen) BOOL    sideBarOpen;
@property (nonatomic) UIViewController              *currentViewController;
@end

@implementation JLSideMenuSlideInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupVariables];
    [self setupUI];
    [self setupNavigation];
}

- (void)setupVariables {
    sideBarViewWidth = self.view.frame.size.width;
}

- (void)setupUI {
    _containerView = [UIView new];
    _containerView.frame = self.view.frame;
    _containerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_containerView];
    UIView *testV = [UIView new];
    testV.frame = self.view.bounds;
    testV.backgroundColor = [UIColor greenColor];
    [_containerView addSubview:testV];
    
    
    _sideBarView = [UIView new];
    _sideBarView.frame = (CGRect) {-sideBarViewWidth, 0, sideBarViewWidth, self.view.frame.size.height};
    
    UIBlurEffect *eff = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    UIVisualEffectView *blurV = [[UIVisualEffectView alloc] initWithEffect:eff];
    blurV.frame = _sideBarView.bounds;
    [_sideBarView addSubview:blurV];
    UITapGestureRecognizer *sideBarTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReceived:)];
    sideBarTapGesture.delegate = self;
    [_sideBarView addGestureRecognizer:sideBarTapGesture];
    UIView *testV2 = [UIView new];
    testV2.frame = (CGRect) {0, 0, sideBarViewWidth/2.0, self.view.frame.size.height};
    testV2.backgroundColor = [UIColor blueColor];
    [_sideBarView addSubview:testV2];
    
    [self.view addSubview:_sideBarView];
}

- (void)setupNavigation {
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Testing" style:UIBarButtonItemStyleDone target:self action:@selector(triggerMenu)];
    
    [self.navigationItem setLeftBarButtonItem: leftBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - OPEN SIDE BAR
- (void)triggerMenu {
    
    __weak JLSideMenuSlideInVC *weakSelf = self;
    
    if ([self isSideBarOpen]) {
        // CLOSE SIDE BAR
        for (UIView *view in weakSelf.sideBarView.subviews){
            if (![view isKindOfClass:UIVisualEffectView.class]){
                view.alpha = 0.7;
            }
        };
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.sideBarView offSetXBy:-sideBarViewWidth];
            for (UIView *view in _sideBarView.subviews){
                if (![view isKindOfClass:UIVisualEffectView.class]){
                    view.alpha = 0;
                }
            };
            //            _containerView.transform = CGAffineTransformIdentity;
            [weakSelf.containerView offSetXBy:-sideBarViewWidth/2.0];
        } completion:^(BOOL finished) {
            _sideBarOpen = false;
        }];
        
    } else {
        // OPEN SIDE BAR
        for (UIView *view in weakSelf.sideBarView.subviews) {
            if (![view isKindOfClass:UIVisualEffectView.class]){
                view.alpha = 0;
            }
        };
        [UIView animateWithDuration:0.25 animations:^{
            [weakSelf.sideBarView offSetXBy:sideBarViewWidth];
            for (UIView *view in weakSelf.sideBarView.subviews){
                if (![view isKindOfClass:UIVisualEffectView.class]){
                    view.alpha = 1;
                }
            };
            //            _containerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
            [weakSelf.containerView offSetXBy:sideBarViewWidth/2.0];
        } completion:^(BOOL finished) {
            _sideBarOpen = true;
        }];
    }
}

- (void)tapGestureReceived:(UITapGestureRecognizer *)tapGesture {
    [self triggerMenu];
}

- (BOOL)isSideBarOpen {
    return _sideBarOpen;
}

#pragma mark - DELEGATE
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:UIVisualEffectView.class]) {
        return true;
    }
    return false;
}

#pragma mark - SELF DELEGATEs


@end
