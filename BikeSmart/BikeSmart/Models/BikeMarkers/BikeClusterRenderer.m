//
//  BikeClusterRenderer.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/25.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeClusterRenderer.h"

@implementation BikeClusterRenderer

- (BOOL)shouldRenderAsCluster:(id<GMUCluster>)cluster atZoom:(float)zoom {
        
    return cluster.count >= 3;
}

@end
