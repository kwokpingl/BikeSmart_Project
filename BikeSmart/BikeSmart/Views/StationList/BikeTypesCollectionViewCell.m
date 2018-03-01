//
//  BikeTypesCollectionViewCell.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/28.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeTypesCollectionViewCell.h"

@implementation BikeTypesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setBikeType:(BikeTypes)bikeType {
    _bikeType = bikeType;
    switch (bikeType) {
        case UBike_CH:
        case UBike_HC:
        case UBike_TP:
        case UBike_TY:
        case UBike_NTP:
            
            break;
            
        default:
            break;
    }
}

@end




