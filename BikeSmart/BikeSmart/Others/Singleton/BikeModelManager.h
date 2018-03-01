//
//  BikeModelManager.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/25.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BikeModel.h"
#import "ServerConnector.h"
#import "RealmUtil.h"
#import "SBNotificationCenter.h"
#import "UserDefaults.h"

typedef void(^ModelHandler)(NSDictionary <NSNumber *,NSArray<BikeModel *> *> *);
typedef void(^CompletionProgressHandler)(int);

@interface BikeModelManager : NSObject


+ (id)shared;
- (void)updateDatawithHandler:(CompletionProgressHandler)progressHandler;
- (void)changeFavoriteBikeModel:(BikeModel *)bikeModel
                completeHandler:(RealmDataChanged)completeHandler;
- (void)fetchDataWithCoordinate:(CLLocation *) coordinate;
- (NSMutableDictionary *)getModelsFor:(BikeTypes) bikeType;
- (NSMutableDictionary *)getAllModel;
- (NSMutableDictionary *)getFavorites;
@end
