//
//  BikeCluster.h
//  BikeSmart
//
//  Created by Jimmy on 2018/1/15.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIFont+JLFont.h"
#import "UIBezierPath+JLBezierPath.h"

#import "BikeModel.h"

@interface BikeCluster : NSObject
+(UIImage *)getClusterImageWithItems:(int) numberOfItem
                            forModel:(__weak BikeModel *) bikeModel
                            withSize:(CGSize) size;
+(UIView *)getClusterViewWithItems:(int) numberOfItem
                          forModel:(__weak BikeModel *) bikeModel
                          withSize:(CGSize) size;
@end
