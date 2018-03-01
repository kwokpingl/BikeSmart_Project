//
//  SBGeneralMainViewController.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/16.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SBGeneralMainViewController.h"

@interface SBGeneralMainViewController ()
@property (nonatomic) UIButton *menuBtn, *searchBtn;
@property (nonatomic) CGFloat barItemHeight;
@end

@implementation SBGeneralMainViewController

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    CGRect navigationButtonFrame = CGRectMake(0, 0, _barItemHeight, _barItemHeight);
    
    if (self.view.frame.size.height < self.view.frame.size.width) {
        navigationButtonFrame = CGRectMake(0, 0, _barItemHeight * 0.7,
                                           _barItemHeight * 0.7);
    }
    
    
    if (_menuBtn != nil) {
        _menuBtn.frame = navigationButtonFrame;
        UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_menuBtn];
        [self.navigationItem setLeftBarButtonItem: leftBarItem];
    }
    
    if (_searchBtn != nil) {
        _searchBtn.frame = navigationButtonFrame;
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
        
        [self.navigationItem setRightBarButtonItem:rightBarItem];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setNavigationUIWhenLayoutSubview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigation];
}

- (void)setupNavigation {
    _barItemHeight = [ContentNavigationBar getDefaultHeight];
    [self setupLeftBarItem];
    [self setupRightBarItem];
}

- (void)setupLeftBarItem {
    
    _menuBtn = [[UIButton alloc] initWithFrame:
                CGRectMake(0, 0, _barItemHeight, _barItemHeight)];
    [_menuBtn addTarget:self action:@selector(leftItemButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_menuBtn setImage:[ImageUtil getMenuImage:MenuIcon_MAINMENU] forState:UIControlStateNormal];
    [_menuBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _menuBtn.layer.cornerRadius = _menuBtn.frame.size.height / 2.0;
    _menuBtn.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:_menuBtn];
    [self.navigationItem setLeftBarButtonItem: leftBarItem];
}

- (void)setupRightBarItem {
    _searchBtn = [[UIButton alloc] initWithFrame:
                  CGRectMake(0, 0, _barItemHeight, _barItemHeight)];
    [_searchBtn addTarget:self action:@selector(rightItemButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_searchBtn setImage:[ImageUtil getMenuImage:MenuIcon_SEARCH] forState:UIControlStateNormal];
    [_searchBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    _searchBtn.layer.cornerRadius = _menuBtn.frame.size.height / 2.0;
    _searchBtn.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
    
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////////////////////////
//                      BAR BUTTON ITEM ACTION
/////////////////////////////////////////////////////////////////////////
#pragma mark - BAR BUTTON ITEM ACTIONs

/**
 rigthItemButtonPressed:
 Override this method to determine how the
 */
- (void) rightItemButtonPressed {
    
}

- (void) leftItemButtonPressed {
    [_generalDelegate openMenu];
}

- (void) setNavigationUIWhenLayoutSubview {
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.barTintColor = [UIColor blackColor];
    self.navigationController.toolbar.backgroundColor = [UIColor blackColor];
}

@end
