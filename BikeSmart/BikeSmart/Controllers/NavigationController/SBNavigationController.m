//
//  SBNavigationController.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SBNavigationController.h"

@interface SBNavigationController ()
@property (nonatomic) SBNavigationTitleView *titleView;
@property (nonatomic) ContentNavigationBar  *contentNavigationBar;

@property (nonatomic) UIViewController *currentViewController;

@property (nonatomic) MainVC *mainVC;
@property (nonatomic) SBStationListVC *stationVC;

@end

@implementation SBNavigationController

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
}

#pragma mark - LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(receivedNotificationForSwitching:) name:Notification_NavigationSwitchTrigger object:nil];
}

- (void)setupNavigationBar {
    [self setValue:[ContentNavigationBar new]forKey:@"navigationBar"];
    [self setValue:[ToolBar new] forKey:@"toolbar"];
    self.toolbarHidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VCs SWITCHER
- (void)removeCurrentViewController {
    [_currentViewController.view removeFromSuperview];
    [_currentViewController removeFromParentViewController];
    [_currentViewController didMoveToParentViewController:nil];
}

- (void)receivedNotificationForSwitching: (NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    VCTypes switchToType = (VCTypes)[info[SWITCHER_VCTYPE_KEY] unsignedIntegerValue];
    
    [self switchTo:switchToType withDictionary:nil];
}

- (void)switchTo:(VCTypes) type withDictionary:(NSDictionary * _Nullable ) data {
    switch (type) {
    case VCType_MAP:
            
            if (_mainVC == nil) {
                _mainVC = [MainVC new];
            }
            _mainVC.generalDelegate = self;
            [self setViewControllers:@[_mainVC]];
        break;
        case VCType_LIST:
            
            _stationVC = nil;
            
            _stationVC = [SBStationListVC new];
            
            _stationVC.generalDelegate = self;
            [self setViewControllers:@[_mainVC, _stationVC]];
            
            break;
    default:
        break;
    }
}

- (void)openMenu {
    [_openMenuDelegate openMenu];
}

-(void)goToHomePage {
    [self switchTo:VCType_MAP withDictionary:nil];
}

@end
