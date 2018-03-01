//
//  RealmFactory.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/13.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definitions.h"
#import "BikeModel.h"

@class BikeModel;

typedef void(^RealmUpdated)(BOOL isLastOne, int percentage);
typedef void(^RealmFetched)(NSDictionary <NSNumber *, NSArray <BikeModel *> *> * _Nonnull dataDictionary);
typedef void(^RealmFetchedWithCoordinate)(NSDictionary <NSNumber *, NSArray <BikeModel *> *> * _Nonnull dataDictionary, CLLocationCoordinate2D coordinate) ;
typedef void(^RealmDataChanged)(BOOL isCompleted);

NS_ROOT_CLASS

@interface RealmUtil
+(void)updateBikeRealmsWithDictionary:(NSDictionary *_Nullable)dataDictionary
                        updateHandler:(RealmUpdated _Nonnull)updateHandler;
+(void)getSelectedBikeRealm:(RealmFetched _Nullable )dataFetchHandler;

+(void)getBikeRealmAtLocation:(CLLocationCoordinate2D)location
                completeHandler:(RealmFetchedWithCoordinate _Nullable)dataFetchHandler;

+ (void)updateBikeModel:(BikeModel *_Nonnull)bikeModel
       completeHandler:(RealmDataChanged _Nonnull)completeHandler;
@end
