//
//  BikeMarker.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/14.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeMarker.h"

@implementation BikeMarker
{
    BikeModel   *_bikeModel;
    NSString    *_imgName;
}

- (instancetype)init:(BikeModel *) bikeModel
{
    self = [super init];
    if (self)
    {
        _bikeModel  = bikeModel;
        _imgName    = [_bikeModel getImageName];
    }
    return self;
}

@end
