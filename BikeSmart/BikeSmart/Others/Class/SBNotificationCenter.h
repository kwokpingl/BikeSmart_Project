//
//  SBNotificationCenter.h
//  BikeSmart
//
//  Created by Jimmy on 2018/2/11.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BikeModel.h"

@interface SBNotificationCenter : NSObject
+ (void)postGeneralModelUpdated:(NSDictionary<NSNumber *,NSArray<BikeModel *> *> *_Nonnull)generalModel withObject:(id _Nullable)object;
+ (void)postNewModelReadyToDisplay:(NSDictionary<NSNumber *,NSArray<BikeModel *> *> *_Nonnull)newModel withObject:(id _Nullable)object;
@end
