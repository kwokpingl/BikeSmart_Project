//
//  SBNotificationCenter.m
//  BikeSmart
//
//  Created by Jimmy on 2018/2/11.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "SBNotificationCenter.h"

@implementation SBNotificationCenter

+ (void)postGeneralModelUpdated:(NSDictionary<NSNumber *,NSArray<BikeModel *> *> *_Nonnull)generalModel withObject:(id _Nullable)object{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BikeManagerModelUpdated object:object userInfo:@{BIKE_MODELs_KEY:generalModel}];
}

+ (void)postNewModelReadyToDisplay:(NSDictionary<NSNumber *,NSArray<BikeModel *> *> *_Nonnull)newModel withObject:(id _Nullable)object{
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_BikeManagerNewModels object:object userInfo:@{BIKE_MODELs_KEY:newModel}];
}



@end
