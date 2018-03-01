//
//  SBGrandMasterVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SBGrandMasterVC.h"

static CGFloat sideBarViewWidth = 100;
static CGFloat centerOffsetX    = 100;

typedef void(^completeAnimate)(BOOL);

@interface SBGrandMasterVC ()
@property (nonatomic) UIView    *containerView;
@property (nonatomic, getter=isSideBarOpen) BOOL      sideBarOpen;

#pragma mark - VIEW CONTROLLERs
@property (nonatomic) SBNavigationController *sbNavigationController;
@property (nonatomic) MenuVC *menuVC;

#pragma mark - TIMER
@property (nonatomic) NSTimer *fetchDataTimer;
@property (nonatomic) NSTimeInterval timeInterval;
@end

@implementation SBGrandMasterVC

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    if (_sbNavigationController != nil && _containerView != nil) {
        _containerView.frame = self.view.bounds;
        _sbNavigationController.view.frame = _containerView.bounds;
    }
}

#pragma mark - LIFE CYCLE
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupVariables];
    [self setupUI];
    [self setupViews];
//    [self prepareDataFetchingTimer];
    
}

- (void)setupVariables {
    centerOffsetX = self.view.frame.size.width * (2.0/3.0);
}

- (void)setupUI {
    _containerView = [UIView new];
    _containerView.frame = self.view.bounds;
}

- (void)setupViews {
    ///////////////////////////
    //      CONTAINER VIEW
    ///////////////////////////
    _sbNavigationController = [SBNavigationController new];
    _sbNavigationController.openMenuDelegate = self;
    _sbNavigationController.view.frame = _containerView.bounds;
    [self addChildViewController:_sbNavigationController];
    [_containerView addSubview:_sbNavigationController.view];
    [_sbNavigationController didMoveToParentViewController:self];
    [self.view addSubview:_containerView];
    
    [_sbNavigationController goToHomePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - OPEN SIDE BAR
- (void)triggerMenu {
    if ([self isSideBarOpen]) {
        _sideBarOpen = false;
        [_menuVC.view removeFromSuperview];
        [self animateMainViewOffset:-centerOffsetX complete:nil];
        _menuVC = nil;
    } else {
        _sideBarOpen = true;
        
        _menuVC = [MenuVC new];
        _menuVC.view.alpha = 0;
        CGRect bounds = self.view.bounds;
        _menuVC.view.frame = CGRectMake(0, 0, centerOffsetX, bounds.size.height);
        _menuVC.menuVCDelegate = self;
        [self addChildViewController:_menuVC];
        [self.view insertSubview:_menuVC.view atIndex:self.view.subviews.count];
        [_menuVC didMoveToParentViewController:self];
        
        [self animateMainViewOffset:centerOffsetX complete:nil];
    }
}

- (BOOL)isSideBarOpen {
    return _sideBarOpen;
}

// Animate Open/Close of SideBar
- (void) animateMainViewOffset:(CGFloat) offset
                      complete:(completeAnimate) complete {
    
    __weak SBGrandMasterVC *weakSelf = self;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.sbNavigationController.view offSetXBy:offset];
        
        if ([weakSelf isSideBarOpen]) {
            weakSelf.menuVC.view.alpha = 1;
        }
        
    } completion:complete];
}

#pragma mark - DELEGATEs
#pragma mark: MAINVC through SBNavigationViewController
- (void)openMenu {
    [self triggerMenu];
}

- (void)switchToViewController:(VCTypes)type {
    [self triggerMenu];
    [NSNotificationCenter.defaultCenter postNotificationName:Notification_NavigationSwitchTrigger object:nil userInfo:@{SWITCHER_VCTYPE_KEY:@(type)}];
}

//#pragma mark - FETCH DATA
//- (void) prepareDataFetchingTimer {
//    _timeInterval = 60.0;
//    _fetchDataTimer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(updateBikeStations) userInfo:nil repeats:true];
//    [_fetchDataTimer fire];
//}


/**
Reload Bike Model through BikeModelManager to Reload BikeModelDictionary
 */
- (void) updateBikeStations {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:date];
    
    NSLog(@"UPDATE : %ld", (long)components.minute);
    
    // Connect to Server
//    [BikeModelManager reloadBikeModelDictionary];
}

- (void) notificationReceived:(NSNotification *) notification {
    NSNotificationName name = notification.name;
    if ([name isEqualToString:Notification_UpdateBikeModels]) {
        [self updateBikeStations];
    }
}
@end
