//
//  ServerConnector.h
//  BikeSmart
//
//  Created by Jimmy on 2017/9/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BikeModel.h"
#import "Definitions.h"

typedef void(^completeHandler)(NSDictionary *_Nullable);
typedef void(^bikeDataHandler)(NSDictionary *_Nullable data, NSError *_Nullable internetError, NSError *_Nullable jsonError, BOOL isSuccess);

@interface ServerConnector : NSObject <NSURLSessionDelegate>
+ (instancetype _Nonnull ) sharedInstance;

- (void)fetchData:(BikeTypes)bikeType completeHandler:(bikeDataHandler _Nonnull ) dataHandler;

- (void)fetchBikeData:(NSArray * _Nullable) bikeTypes completeHandler:(bikeDataHandler _Nonnull) dataHandler;
@end
