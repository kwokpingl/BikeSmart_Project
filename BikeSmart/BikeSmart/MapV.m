//
//  MapV.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MapV.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation MapV
{
    CLLocationManager * cLMgr;
    NSTimer * timer;
    GMSCameraPosition * camera;
    GMSMapView * gMapV;
    BOOL shouldUpdateUserLocation;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        shouldUpdateUserLocation = true;
        
        [self setupView];
        
        cLMgr = [CLLocationManager new];
        cLMgr.delegate = self;
        if ([cLMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [cLMgr requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void) setupView {
    gMapV = [GMSMapView new];
    gMapV.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:gMapV];
    
    NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:gMapV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint * leading = [NSLayoutConstraint constraintWithItem:gMapV attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint * trailing = [NSLayoutConstraint constraintWithItem:gMapV attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:gMapV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self addConstraints:@[top, leading, trailing, bottom]];
}

// Customized Request for Authorization
/* 
 Status =>
 kCLAuthorizationStatusDenied               => @"Location Services are Off"
 kCLAuthroizationStatusAuthorizedWhenInUse  => @"Background location is not enabled"
 */
- (void) requestAlwaysAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSString * str;
        str = (status == kCLAuthorizationStatusDenied) ? @"Location Services are Off" : @"Background location is not enabled";
        NSString * msg = @"To use background location, you must turn on 'Always' in the Location Services Settings";
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:str
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        // Open Setting URL if user pressed the Settings Btn
        UIAlertAction * settings = [UIAlertAction actionWithTitle:@"Settings"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        NSURL * settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                        [[UIApplication sharedApplication] openURL:settingsURL];
        }];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
        
        [alert addAction:settings];
        [alert addAction:cancel];
        [_delegate mapV:self presentAlert:alert];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [cLMgr requestAlwaysAuthorization];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    camera = [GMSCameraPosition cameraWithTarget:locations.firstObject.coordinate zoom:15];
    [gMapV setCamera:camera];
    
    [cLMgr stopUpdatingLocation];
    [cLMgr stopUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [cLMgr startUpdatingLocation];
        
        // Show User Location and User Location Btn
        gMapV.myLocationEnabled         = true;
        // draws a light blue dot where the user is located
        gMapV.settings.myLocationButton = true;
        // adds a button to the map that, when tapped, centers the map on the user’s location
    } else {
        [self requestAlwaysAuthorization];
    }
}

- (void) reverseGeocodeCoordinate: (CLLocationCoordinate2D) coordinate {
    GMSGeocoder * geoCoder = [GMSGeocoder new];
    [geoCoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        
    }];
}

@end
