//
//  MileStone.h
//  BikeSmart
//
//  Created by Jimmy on 2018/1/26.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MileStone : NSObject
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *info;
@end
