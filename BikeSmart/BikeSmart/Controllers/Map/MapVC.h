//
//  MapVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/6.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
//#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>

#import "UIColor+JLColor.h"
#import "UIView+JLView.h"
#import "UIImage+JLImage.h"
#import "UIView+JLView.h"
#import "UIFont+JLFont.h"
#import "NSDictionary+NSDictionary_JLDictionary.h"

#import "BikeModel.h"
#import "BikeModelManager.h"
#import "Constants.h"

#import "BikeClustersManager.h"
#import "BikeClusterRenderer.h"
#import "BikeClusterItem.h"
#import "BikeCluster.h"
#import "BikeMarkerIconView.h"

@interface MapVC : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate>

- (void) displayBikeMarkersWithBikeModels:(NSDictionary <NSNumber *,NSArray<BikeModel *> *> *) bikeData;

- (MKCoordinateRegion)getCurrentRegion;

- (void)fetchCurrentLocationDataFromRealm;

@end
