//
//  BikeMarker.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/14.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "BikeModel.h"

@interface BikeMarker : GMSMarker
- (instancetype)init:(BikeModel *) bikeModel;
@end
