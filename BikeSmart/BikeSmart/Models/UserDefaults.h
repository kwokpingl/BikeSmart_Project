//
//  UserDefaults.h
//  BikeSmart
//
//  Created by Jimmy on 2018/2/12.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "BikeModel.h"

@interface UserDefaults : NSObject
+ (NSTimeInterval)getUpdateTimeInterval;
+ (void)setUpdateTimeInterval:(NSTimeInterval)newUpdateTimeInterval;

+ (NSArray<NSNumber *> *)getSelectedBikeTypes;
+ (void)setSelectedBikeTypes:(NSArray<NSNumber *> *)newBikeTypes;
@end
