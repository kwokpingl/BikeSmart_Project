//
//  BikeClusters.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
//#import <Google-Maps-iOS-Utils/GMUClusterRenderer.h>

#import "BikeClusterRenderer.h"
#import "BikeClusterItem.h"
#import "BikeModel.h"

@interface BikeClustersManager: GMUClusterManager

- (instancetype)initWithMap:(GMSMapView *)mapView withRenderDelegate:(id<GMUClusterRendererDelegate>) renderDelegate;

@end
