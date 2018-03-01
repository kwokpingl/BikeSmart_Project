//
//  MileStone.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/26.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "MileStone.h"

@interface MileStone()

@end

@implementation MileStone

- (instancetype)initWith:(CLLocationCoordinate2D)coordinate
                    info:(NSString *)info {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _info = info;
    }
    return self;
}

@end
