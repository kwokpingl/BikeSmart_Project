//
//  MapVC.m
//  BikeSmart
//
//  Responsible for Updating Camera Location -> which triggers Fetching Data from Realm using Feedback
//
//  2018/01/08
//  Slight changes ->
//      1. Instead of receiving data after every data been updated,
//          data shall be fetched by the map when ever camera has been
//          moved. The data fetched will be based on the location of the
//          camera and not the user location. (hoping to save some battery)
//      2. In order to set MULTIPLE milestones, a shared class that holds
//          the current milestones, based on a NSObject that holds
//          COORDINATEs and NAMEs
//
//
//
//
//
//
//
//
//  Created by Jimmy on 2017/11/6.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()
@property (nonatomic) CLLocationManager *cLMgr;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) CGFloat secondCounter;

@property (nonatomic) GMSCameraPosition *camera;
@property (nonatomic) GMSMapView *gMapV;

@property (nonatomic) CLLocationCoordinate2D cameraPosition, previousCameraLocation, userLocation;

@property (nonatomic) BOOL shouldUpdateUserLocation, shouldUpdateClusters;

// Save the image that where used and use the same instance of the image for markers.
@property (nonatomic) NSMutableDictionary <NSString *, UIImage *> *icons, *clusterIcons;
@property (nonatomic) NSMutableDictionary <NSString *, BikeModel *> *modelDictionary;
@property (nonatomic) NSMutableDictionary <NSString *, BikeClusterItem *> *clusterItems, *favoriteItems;
@property (nonatomic) BikeClustersManager *UBike_TY_ClusterMgr, *UBike_NTP_ClusterMgr, *UBike_HC_ClusterMgr, *UBike_CH_ClusterMgr, *TBike_TN_ClusterMgr, *PBike_PD_ClusterMgr, *KBike_KM_ClusterMgr, *IBike_HCC_ClusterMgr, *EBike_CY_ClusterMgr, *CBike_KS_ClusterMgr, *favorite_ClusterMgr, *UBike_TP_ClusterMgr;

@property (nonatomic) BikeModelManager *bikeManager;

@property (nonatomic) BOOL isFirstLoad;
@end

@implementation MapVC
////////////////////////////////////////
//          Life Cycle
////////////////////////////////////////
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    [self setupGoogleMapVariables];
    [self addNotifications];
    _isFirstLoad = true;
}

- (void) setup {
    _shouldUpdateUserLocation = false;
    
    [self setupView];
    
    _cLMgr = [CLLocationManager new];
    _cLMgr.delegate = self;
    if ([_cLMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_cLMgr requestAlwaysAuthorization];
    }
    
    _icons          = [NSMutableDictionary new];
    _clusterIcons   = [NSMutableDictionary new];
    _modelDictionary= [NSMutableDictionary new];
    _favoriteItems  = [NSMutableDictionary new];
    _clusterItems   = [NSMutableDictionary new];
    
    _secondCounter  = 1.5; // Setup as 1.5 Seconds before the clusters update
}

- (void) setupView {
    GMSCameraPosition *cameraPosition = [[GMSCameraPosition alloc] initWithTarget:CLLocationCoordinate2DMake(0, 0) zoom:15 bearing:0 viewingAngle:0];
    _gMapV = [GMSMapView mapWithFrame:CGRectZero camera:cameraPosition];
    _gMapV.translatesAutoresizingMaskIntoConstraints = false;
    
    [self.view addSubview:_gMapV];
    
    _gMapV.delegate = self;
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:_gMapV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:_gMapV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:_gMapV attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_gMapV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraints:@[top, leading, trailing, bottom]];
}


- (void)setupGoogleMapVariables {
    
    _UBike_NTP_ClusterMgr   = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _IBike_HCC_ClusterMgr   = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _TBike_TN_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _PBike_PD_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _KBike_KM_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _EBike_CY_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _CBike_KS_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _UBike_TY_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _UBike_HC_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _UBike_CH_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    _favorite_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
    
    _UBike_TP_ClusterMgr    = [[BikeClustersManager alloc] initWithMap:_gMapV withRenderDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _bikeManager = [BikeModelManager shared];
    
    if (_camera != nil && _modelDictionary.allKeys.count == 0) {
        
        [_bikeManager fetchDataWithCoordinate:[[CLLocation alloc] initWithLatitude:_cameraPosition.latitude longitude:_cameraPosition.longitude]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:Notification_BikeManagerModelUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReceived:) name:Notification_BikeManagerNewModels object:nil];
}

#pragma mark - REQUEST AUTHORIZATION
- (void) requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSString * str;
        
        str = (status == kCLAuthorizationStatusDenied) ? @"Location Services are Off" : @"Background location is not enabled";
        NSString * msg = @"To use background location, you must turn on 'Always' in the Location Services Settings";
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:str message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        // Open Setting URL if user pressed the Settings Btn
        UIAlertAction * settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication]
             openURL:settingsURL];
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
        
        [alert addAction:settings];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [_cLMgr requestAlwaysAuthorization];
    }
}

////////////////////////////////////////////
//          CLLocation Manager Protocol
////////////////////////////////////////////
#pragma mark - CLLocationManager Protocol

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    _userLocation = locations.firstObject.coordinate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_UserLocation object:locations.firstObject];
    
    _camera = [GMSCameraPosition cameraWithTarget:_userLocation zoom:15];
    [_gMapV setCamera:_camera];
    
    /// USER Current Location
    if (!_shouldUpdateUserLocation) {
        [_cLMgr stopUpdatingLocation];
        [_cLMgr stopUpdatingHeading];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [_cLMgr startUpdatingLocation];
        
        // Show User Location and User Location Btn
        _gMapV.myLocationEnabled         = true;
        // draws a light blue dot where the user is located
        _gMapV.settings.myLocationButton = true;
        // adds a button to the map that, when tapped, centers the map on the user’s location
        
    } else {
        [self requestAlwaysAuthorization];
    }
}


/**
 Get the GeoCode from CLLocationCoordinate2D
 
 @param coordinate CLLocationCoordinate2D
 */
- (void) reverseGeocodeCoordinate: (CLLocationCoordinate2D) coordinate
{
    GMSGeocoder * geoCoder = [GMSGeocoder new];
    
    // 台灣 zh-Hant-TW 英文 en
    
    NSLog(@"%@",[[NSLocale preferredLanguages] firstObject]);
    
    [geoCoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        
        if (error != nil) {
            NSLog(@"ERROR : %@", error.localizedDescription);
            return;
        }
        
        NSString * locality = response.firstResult.locality;
        NSString * adminArea = response.firstResult.administrativeArea;
        
        //        [_feedBackDelgate newLocationDetected:locality AdminArea:adminArea];
        // +0.000171
//        NSLog(@"%@", response.firstResult.administrativeArea);
//        NSLog(@"=========================");
//        NSLog(@"%@", response.firstResult.locality);
//        NSLog(@"*************************");
//        NSLog(@"%@", response.firstResult.country);
//        NSLog(@"Lat: %.6f, Lng: %.6f", (double) coordinate.latitude, (double) coordinate.longitude);
    }];
}

/////////////////////////////////////////////
//          GOOGLE MAP DELEGATE
/////////////////////////////////////////////
#pragma mark - Google Map Protocol
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    _cameraPosition = position.target;
    
    [self reverseGeocodeCoordinate:position.target];
    
    CLLocation *cameraLocation = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];
    
    // NOTIFY MAINVC change in CAMERA LOCATION => Show correct Weather
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_CameraLocation object:cameraLocation];
    
    // ONLY FETCH DATA in 2 conditions
    // 1. loading the FIRST TIME
    // 2. COORDINATE checks out AND the timer is enough
    if (([self coordinationCheckOut] && _secondCounter > 0.8) || _isFirstLoad){
        _isFirstLoad = false;
        _previousCameraLocation = _cameraPosition;
        [self fetchCurrentLocationDataFromRealm];
    }
}

- (void)renderer:(id<GMUClusterRenderer>)renderer willRenderMarker:(GMSMarker *)marker {
    
    if ([marker.userData isKindOfClass:[BikeClusterItem class]]) {
        
        [self renderClusterItem:marker];
        
    } else if ([marker.userData conformsToProtocol:@protocol(GMUCluster)]) {
        [self renderCluster:marker];
    }
}

- (void)renderClusterItem:(GMSMarker *)marker {
    BikeClusterItem *currentMarker = marker.userData;
    
    NSString *iconKey   = [currentMarker getClusterItemKey];
    NSString *modelKey  = [currentMarker getUniqueKey];
    
    BikeModel *bikeModel = [[BikeModelManager shared] getAllModel][modelKey];
    
    if (_icons[iconKey] == nil) {
        
        if ([currentMarker isFavorite]) {
            
        } else {
            
        }
        
        _icons[iconKey] = [BikeClusterItem getIconWithRect:CGRectMake(0, 0, 60, 80) forBikeModel:bikeModel];
    }
    
    if ([currentMarker isFavorite]) {
        
    }
    
    marker.icon = _icons[iconKey];
    
    marker.title = [bikeModel getAddress];
    marker.tracksViewChanges = false;
}

- (void)renderCluster:(GMSMarker *)marker {
    id<GMUCluster> currentCluster = marker.userData;
    
    int numberOfItems = (int)currentCluster.items.count;
    
    if ([currentCluster.items.firstObject isKindOfClass:[BikeClusterItem class]]) {
        BikeClusterItem *clusterItem = (BikeClusterItem *)currentCluster.items.firstObject;
        
        BikeModel *bikeModel = _modelDictionary[clusterItem.getUniqueKey];
        NSString *key = [bikeModel getStationDistrict];
        
        if (_clusterIcons[key] == nil) {
            _clusterIcons[key] = [BikeCluster getClusterImageWithItems:numberOfItems forModel:bikeModel withSize:CGSizeMake(80, 80)];
        }
        
        marker.icon = _clusterIcons[key];
    }
    
    marker.groundAnchor = CGPointMake(0.5, 0.5);
    marker.tracksViewChanges = false;
}


//////////////////////////////////////////
//      Methods for UPDATEs
//////////////////////////////////////////
#pragma mark - MARKERs / CLUSTERs METHODs

/**
 Fetch Data based on the Coordinate.
 Only display them if the Coordinate stays the same.
 */
- (void)fetchCurrentLocationDataFromRealm {
    
    // FETCH DATA from Current Location
    [[BikeModelManager shared] fetchDataWithCoordinate:[[CLLocation alloc] initWithLatitude:_cameraPosition.latitude longitude:_cameraPosition.longitude]];
}

- (void) displayBikeMarkersWithBikeModels:(NSDictionary <NSNumber *,NSArray<BikeModel *> *> *) bikeData
{
    NSLog(@"%s", __FUNCTION__);
    for (NSNumber *bikeTypeRaw in bikeData.allKeys) {
        NSArray <BikeModel *> *newModels = bikeData[bikeTypeRaw];
        
        NSMutableArray<BikeClusterItem *> *clusterItems = [NSMutableArray new];
        NSMutableArray<BikeClusterItem *> *favoriteItems = [NSMutableArray new];
        
        BikeTypes type = UBike_CH;
        
        for (BikeModel *bikeModel in newModels) {
            
            CLLocationCoordinate2D position = [bikeModel getCoordinate].coordinate;
            
            BikeClusterItem *clusterItem = [[BikeClusterItem alloc]
                                            initWithPosition:position
                                            bikeModel:bikeModel];
            type = [bikeModel getBikeType];
            
            NSString *modelKey = [bikeModel getUniqueKey];
            
            BOOL isFavorite = [bikeModel isFavorite];
            
            // SAVE to FAVORITE CLUSTER MANAGER
            
            BikeClusterItem *oldClusterItem = _clusterItems[modelKey];
            
            [self removeItem:oldClusterItem isFavorite:isFavorite forBikeType:type];
            
            if (isFavorite) {
                _favoriteItems[modelKey] = clusterItem;
                [favoriteItems addObject:clusterItem];
            } else {
                _clusterItems[modelKey] = clusterItem;
                [clusterItems addObject:clusterItem];
            }
            
        }
        
        if (favoriteItems.count > 0) {
            // FAVORITE CLUSTER MGR addITEM
            [self addClusterItems:favoriteItems isFavorite:true forBikeType:type];
        }
        
        [self addClusterItems:clusterItems isFavorite:false forBikeType:type];
        
        [self redrawAllCluster];
    }
}

- (void)addClusterItems:(NSMutableArray<BikeClusterItem *> *)clusterItems
             isFavorite:(BOOL)isFavorite
            forBikeType:(BikeTypes)type {
    
    if (isFavorite) {
        [_favorite_ClusterMgr addItems:clusterItems];
        return;
    }
    
    switch (type) {
        case UBike_CH:
        {
            [_UBike_CH_ClusterMgr addItems:clusterItems];
        }
            break;
        case UBike_HC:
        {
            [_UBike_HC_ClusterMgr addItems:clusterItems];
        }
            break;
        case UBike_TY:
        {
            [_UBike_TY_ClusterMgr addItems:clusterItems];
        }
            break;
        case UBike_NTP:
        {
            [_UBike_NTP_ClusterMgr addItems:clusterItems];
        }
            break;
        case UBike_TP:
        {
            [_UBike_TP_ClusterMgr addItems:clusterItems];
        }
            break;
        case CBike_KS:
        {
            [_CBike_KS_ClusterMgr addItems:clusterItems];
        }
            break;
        case EBike_CY:
        {
            [_EBike_CY_ClusterMgr addItems:clusterItems];
        }
            break;
        case KBike_KM:
        {
            [_KBike_KM_ClusterMgr addItems:clusterItems];
        }
            break;
        case PBike_PD:
        {
            [_PBike_PD_ClusterMgr addItems:clusterItems];
        }
            break;
        case TBike_TN:
        {
            [_TBike_TN_ClusterMgr addItems:clusterItems];
        }
            break;
        case IBike_TC:
        {
            [_IBike_HCC_ClusterMgr addItems:clusterItems];
        }
            break;
    }
}

- (void)removeItem:(BikeClusterItem *)clusterItem
        isFavorite:(BOOL)isFavorite
       forBikeType:(BikeTypes)type
{
    NSString *key = [clusterItem getUniqueKey];
    
    if (clusterItem == nil){
        return;
    }
    
    if (!isFavorite) {
        [_favorite_ClusterMgr removeItem:clusterItem];
        [_favoriteItems removeObjectForKey:key];
        return;
    }
    
    [_clusterItems removeObjectForKey:key];
    
    switch (type) {
        case UBike_CH:
        {
            [_UBike_CH_ClusterMgr removeItem:clusterItem];
        }
            break;
        case UBike_HC:
        {
            [_UBike_HC_ClusterMgr removeItem:clusterItem];
        }
            break;
        case UBike_TY:
        {
            [_UBike_TY_ClusterMgr removeItem:clusterItem];
        }
            break;
        case UBike_NTP:
        {
            [_UBike_NTP_ClusterMgr removeItem:clusterItem];
        }
            break;
        case UBike_TP:
        {
            [_UBike_TP_ClusterMgr removeItem:clusterItem];
        }
            break;
        case CBike_KS:
        {
            [_CBike_KS_ClusterMgr removeItem:clusterItem];
        }
            break;
        case EBike_CY:
        {
            [_EBike_CY_ClusterMgr removeItem:clusterItem];
        }
            break;
        case KBike_KM:
        {
            [_KBike_KM_ClusterMgr removeItem:clusterItem];
        }
            break;
        case PBike_PD:
        {
            [_PBike_PD_ClusterMgr removeItem:clusterItem];
        }
            break;
        case TBike_TN:
        {
            [_TBike_TN_ClusterMgr removeItem:clusterItem];
        }
            break;
        case IBike_TC:
        {
            [_IBike_HCC_ClusterMgr removeItem:clusterItem];
        }
            break;
    }
    
}

- (void)redrawAllCluster {
    
    // ONLY UPDATE if the COORDINATE changes is great enough
    if ([self coordinationCheckOut]) {
        return;
    }
    
    [_favorite_ClusterMgr cluster];
    
    [_UBike_HC_ClusterMgr cluster];
    [_UBike_NTP_ClusterMgr cluster];
    [_UBike_CH_ClusterMgr cluster];
    [_UBike_TY_ClusterMgr cluster];
    [_UBike_TP_ClusterMgr cluster];
    
    [_CBike_KS_ClusterMgr cluster];
    
    [_KBike_KM_ClusterMgr cluster];
    
    [_PBike_PD_ClusterMgr cluster];
    [_EBike_CY_ClusterMgr cluster];
    [_TBike_TN_ClusterMgr cluster];
    [_IBike_HCC_ClusterMgr cluster];
}

#pragma mark - CLLOCATION UPDATE CONTROLLERs
- (void)startFollowUser {
    _shouldUpdateUserLocation = true;
    [_cLMgr startUpdatingLocation];
    [_cLMgr startUpdatingHeading];
}

- (void)stopFollowUser {
    _shouldUpdateUserLocation = false;
}

#pragma mark - OTHER METHODs

- (MKCoordinateRegion) getCurrentRegion {
    GMSVisibleRegion region = _gMapV.projection.visibleRegion;
    CLLocationCoordinate2D nearLeft     = region.nearLeft;
    CLLocationCoordinate2D nearRight    = region.nearRight;
    CLLocationCoordinate2D farLeft      = region.farLeft;
    CLLocationCoordinate2D farRight     = region.farRight;
    
    // CREATE Arrays of LATs and LNGs
    NSArray *lats = @[@(nearLeft.latitude), @(nearRight.latitude), @(farLeft.latitude), @(farRight.latitude)];
    NSArray *lngs = @[@(nearLeft.longitude), @(nearRight.longitude), @(farLeft.longitude), @(farRight.longitude)];
    
    CLLocationDegrees maxLat = [lats[0] doubleValue];
    CLLocationDegrees minLat = [lats[0] doubleValue];
    CLLocationDegrees maxLng = [lngs[0] doubleValue];
    CLLocationDegrees minLng = [lngs[0] doubleValue];
    
    // DETERMINE the correct Max and Min of Lat and Lng
    for (NSNumber *lat in lats) {
        if ([lat doubleValue] > maxLat) {
            maxLat = [lat doubleValue];
        }
        
        if ([lat doubleValue] < minLat) {
            minLat = [lat doubleValue];
        }
    }
    
    for (NSNumber *lng in lngs) {
        if ([lng doubleValue] > maxLng) {
            maxLng = [lng doubleValue];
        }
        
        if ([lng doubleValue] < minLng) {
            minLng = [lng doubleValue];
        }
    }
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(minLat + (maxLat - minLat)/2.0, minLng + (maxLng - minLng)/2.0);
    MKCoordinateSpan span = MKCoordinateSpanMake((maxLat - minLat) * 1.1, (maxLng - minLng) * 1.1);
    return MKCoordinateRegionMake(center, span);
}

- (BOOL)coordinationCheckOut {
    CGFloat deltaLat = DELTA_LAT;
    CGFloat deltaLng = DELTA_LNG;
    
    CGFloat currentDeltaLat = fabs(_cameraPosition.latitude - _previousCameraLocation.latitude);
    
    CGFloat currentDeltaLng = fabs(_cameraPosition.longitude - _previousCameraLocation.longitude);
    
    return (deltaLng < currentDeltaLng || deltaLat < currentDeltaLat);
}

- (void)createTimer {
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
        _secondCounter = 0;
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(secondCounterTriggered:) userInfo:nil repeats:true];
}

- (void)secondCounterTriggered:(NSTimer *) timer {
    _secondCounter += 0.1;
}


#pragma mark - NOTIFICATION RECEIVERs
- (void)notificationReceived:(NSNotification *)notification {
    NSString * name = notification.name;
    
    NSDictionary <NSNumber *,NSArray<BikeModel *> *> * models = notification.userInfo[BIKE_MODELs_KEY];
    
    if ([name isEqualToString:Notification_BikeManagerNewModels]) {
        // New Model ready to be displayed
        if (models != nil) {
            [self displayBikeMarkersWithBikeModels:models];
        }
        
    } else if ([name isEqualToString:Notification_BikeManagerModelUpdated]) {
        if (models != nil) {
            _modelDictionary = [[NSMutableDictionary alloc] initWithDictionary:models];
        }
    }
    
}


@end
