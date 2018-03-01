//
//  UserDefaults.m
//  BikeSmart
//
//  Created by Jimmy on 2018/2/12.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "UserDefaults.h"

static NSString * const updateTimeInterval_Key = @"updateTimeInterval";
static NSTimeInterval updateTimeInterval = 60;

static NSString * const selectedBikeTypes_Key = @"selectedBikeTypes";

@interface UserDefaults()

@end

@implementation UserDefaults

#pragma mark - Updating Time Interval
+ (NSTimeInterval)getUpdateTimeInterval {
    NSNumber *timeInterval = [[NSUserDefaults standardUserDefaults] objectForKey:updateTimeInterval_Key];
    
    if (timeInterval == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:updateTimeInterval] forKey:updateTimeInterval_Key];
        timeInterval = @(updateTimeInterval);
    }
    
    return timeInterval.doubleValue;
}

+ (void)setUpdateTimeInterval:(NSTimeInterval)newUpdateTimeInterval {
    
    updateTimeInterval = newUpdateTimeInterval;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:updateTimeInterval] forKey:updateTimeInterval_Key];
}

#pragma mark - Selected Bike Types
+ (NSArray<NSNumber *> *)getSelectedBikeTypes {
    
    NSArray<NSNumber *> *bikeTypes = [[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_BikeType];
    
    if (bikeTypes == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@(UBike_TY), @(UBike_NTP), @(UBike_TP)] forKey:UserDefault_BikeType];
        
        bikeTypes = [[NSUserDefaults standardUserDefaults] objectForKey:selectedBikeTypes_Key];
        
    }
    
    return bikeTypes;
}

+ (void)setSelectedBikeTypes:(NSArray<NSNumber *> *)newBikeTypes {
    
    NSArray<NSNumber *> *bikeTypes = [[NSUserDefaults standardUserDefaults] objectForKey:selectedBikeTypes_Key];
    
    if (bikeTypes == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@(UBike_TY), @(UBike_NTP), @(UBike_TP)] forKey:selectedBikeTypes_Key];
    } else if (newBikeTypes == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@[@(UBike_TY), @(UBike_NTP), @(UBike_TP)] forKey:selectedBikeTypes_Key];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:bikeTypes forKey:selectedBikeTypes_Key];
    }
}

#pragma mark - Delta Latitude / Longitude


@end
