//
//  SBStationListVC.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/10.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "SBStationListVC.h"

static NSString *bikeMgr_ModelDictionary_Keypath = @"modelDictionary";

@interface SBStationListVC ()
@property (nonatomic) UICollectionView *bikeTypesCollectionView;
@property (nonatomic) UICollectionView *stationListCollectionView;
@property (nonatomic) UICollectionViewFlowLayout *bikeTypesColletionViewFlowLayout;
@property (nonatomic) UICollectionViewFlowLayout *stationListCollectionViewFlowLayout;
@property (nonatomic) BikeModelManager *bikeMgr;
@end

@implementation SBStationListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:Notification_BikeManagerModelUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:Notification_UserLocation object:nil];
}

#pragma mark - UI SETUP
- (void)setupBikeTypeListView {
    _bikeTypesColletionViewFlowLayout = [UICollectionViewFlowLayout new];
    _bikeTypesColletionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    _bikeTypesColletionViewFlowLayout.
    
    _bikeTypesCollectionView = [[UICollectionView alloc]
                                initWithFrame:CGRectZero
                                collectionViewLayout:[UICollectionViewFlowLayout new]];
    _bikeTypesCollectionView.delegate = self;
}

- (void)setupStationListView {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_bikeMgr removeObserver:self forKeyPath:bikeMgr_ModelDictionary_Keypath];
    
}


#pragma mark - OBSERVERs
- (void)notificationReceived:(NSNotification *)notification {
    NSString *name = notification.name;
    
    if ([name isEqualToString:Notification_UserLocation]) {
        // Update the collectionView with new User Location
        
        
    } else if ([name isEqualToString:Notification_BikeManagerModelUpdated]){
        // Update the collectionView with new Bike Models
        
    }
}

@end
