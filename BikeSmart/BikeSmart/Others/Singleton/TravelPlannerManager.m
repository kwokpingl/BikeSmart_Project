//
//  TravelPlannerManager.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/26.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "TravelPlannerManager.h"

@interface TravelPlannerManager()
@property (nonatomic, strong) NSMutableArray<MileStone *> *mileStones;
@end

@implementation TravelPlannerManager

+ (id)share {
    static TravelPlannerManager *share = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        if (share == nil) {
            share = [TravelPlannerManager new];
            share.mileStones = [NSMutableArray new];
        }
    });
    
    return share;
}


- (void)addMileStone:(MileStone *)mileStone {
    [_mileStones addObject:mileStone];
}

- (void)clearMileStons {
    _mileStones = [NSMutableArray new];
}

- (void)swap:(int)fromIndex to:(int)toIndex {
    [_mileStones swapIndex:fromIndex withIndex:toIndex];
}

@end
