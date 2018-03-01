//
//  MainVC.m
//  BikeSmart
//
//  Main responsiblity is the Connection between Server and Realm, update every minutes
//  < the time to update will be based on the time first enter MainVC, such that number of access to server will be limited, hopefully>
//
//  The MainVC will also be responsible for
//  1. fetching data from Realm and ask MapVC to display them
//
//  ========== 2. getting user location and Camera Location from the MapVC =================
//
//  This will not be needed, because Fetching the Realm everytime the camera moves tends to be
//  too much of burden for the hardware, causing laggings to the UI and reduces UX dramatically.
//
//  Instead, all selected data will be prefetched and shown on the map using Cluster.
//
//  ========================================================================================
//
//  In order to do this, I can use notification to get User Location Change
//  Why use Notification?
//      Because I want to stop MainVC from fetching data from Realm while another VC will be doing the same thing.
//
//
//
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MainVC.h"

static CGFloat sideMenuBtnDefaultWidth = 25;

@interface MainVC ()

@property (nonatomic) UIView        *containerV;

@property (nonatomic) UISearchBar   *searchBar;
@property (nonatomic) NSString      *menuBtnItemName;
@property (nonatomic) NSString      *searchBtnItemName;

@property (nonatomic) CLLocationCoordinate2D    cameraLocation;
@property (nonatomic) MapVC                     *mapVC;

@property (nonatomic) UIButton *menuBtn, *searchBtn;

@property (nonatomic) UISearchController *searchController;
@end

@implementation MainVC 

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if (_mapVC != nil && _containerV != nil) {
        [self setupView];
        _mapVC.view.frame = _containerV.bounds;
    }
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    [self setupVariables];
    [self setupNavigationBar];
    [self createUI];
    [self setupView];
    [self setupChildViewControllers];
}


- (void) setupVariables {
    _menuBtnItemName        = @"Menu";
    _searchBtnItemName      = @"Search";
    _searchController       = nil;
}

- (void) createUI {
    _containerV = [UIView new];
    [self.view addSubview:_containerV];
}

- (void)setupView {
    CGFloat width       = self.view.frame.size.width;
    CGFloat height      = self.view.frame.size.height;
    CGFloat statusH     = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navH        = [ContentNavigationBar getDefaultHeight];
    CGFloat toolH       = [ToolBar getDefaultHeight];
    CGRect  mapVFrame   = (CGRect) {0, statusH + navH, width, height - statusH - navH - toolH};
    
    _containerV.frame = mapVFrame;
}

- (void)setupNavigationBar {
    /// Setup navigationBar with the new NavigationBar Class
    
    SBNavigationTitleView *uiView = [SBNavigationTitleView new];
    uiView.frame = self.navigationController.navigationBar.frame;
    self.navigationItem.titleView = uiView;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setupChildViewControllers {
    // Add ChildViewController
    _mapVC      = [MapVC new];
    _mapVC.view.frame = _containerV.bounds;
    [_containerV addSubview:_mapVC.view];
    [self addChildViewController:_mapVC];
    [_mapVC didMoveToParentViewController:self];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"didAppear");
    // Since mainVC will show the map, so it will only need to observe Camera Location
    [self.navigationItem.titleView setNeedsLayout];
    
    // RECEIVE CameraLocation Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:Notification_CameraLocation object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CUSTOM SBGeneralMainVIEWCONTROLLER METHODs
- (void)rightItemButtonPressed {
    LocationSearchTVC *searchTVC = [LocationSearchTVC new];
    searchTVC.currentRegion = [_mapVC getCurrentRegion];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:searchTVC];
    _searchController.searchResultsUpdater = searchTVC;
    
    // Setup SEARCH BAR
    _searchBar = _searchController.searchBar;
    [_searchBar sizeToFit];
    _searchBar.placeholder = NSLocalizedString(@"Search for Places", @"");
    
    [self presentViewController:_searchController animated:true completion:nil];
}

#pragma mark - Action Methods
/////////////////////////////////////////////
//      Search Bar
/////////////////////////////////////////////



/////////////////////////////////////////////
//          UPDATE BIKE STATIONS
// 1. fetchBikeData
//      this is done at the LaunchView, write or update all the Database
// 2. updateBikeStations
//      called at viewDidLoad, it will be called every "updateMinute" minutes
//
/////////////////////////////////////////////
#pragma mark - Other Functions
- (void) updateBikeStations {
//    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UpdateBikeModels object:nil];
}

- (void) cameraLocationChanged:(CLLocationCoordinate2D)cameraLocation {
    
}

#pragma mark - Notification Methods
// Receive Notification with Data on
//      1. UserDefault
//      2. Camera Location -> To update current weather as well as Data to fetch
- (void) notificationReceived:(NSNotification *) notification {
    NSNotificationName name = notification.name;
    
    if (name == NSUserDefaultsDidChangeNotification) {
        
// FIX
        
    }
    else if ([name isEqualToString:Notification_CameraLocation]) {
        
        // When CameraLocation Updated
        if (notification.object){
            _cameraLocation = ((CLLocation *) notification.object).coordinate;
            NSLog(@"UserLocation : (%f, %f)", _cameraLocation.latitude, _cameraLocation.longitude);
            [self cameraLocationChanged:_cameraLocation];
        }
    }
}


@end
