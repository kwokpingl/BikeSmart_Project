//
//  BikeClusterItem.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/24.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Google-Maps-iOS-Utils/GMUMarkerClustering.h>
#import <CoreLocation/CoreLocation.h>
#import "BikeModel.h"
#import "UIFont+JLFont.h"

@interface BikeClusterItem : NSObject <GMUClusterItem>
@property(nonatomic, readonly) CLLocationCoordinate2D position;

+ (UIImage *)getIconWithRect:(CGRect)iconSize
                forBikeModel:(BikeModel *) bikeModel;

- (instancetype)initWithPosition:(CLLocationCoordinate2D)position
                  bikeModel:(BikeModel *) bikeModel;
- (NSString *)getClusterItemKey;
- (NSString *)getUniqueKey;
- (BOOL)isFavorite;
@end
