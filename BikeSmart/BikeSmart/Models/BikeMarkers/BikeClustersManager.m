//
//  BikeClusters.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/23.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeClustersManager.h"

@interface BikeClustersManager()
//@property (nonatomic) NSMutableDictionary
//            <NSString *, BikeClusterItem *> *currentItems;
@end

@implementation BikeClustersManager

- (instancetype)initWithMap:(GMSMapView *)mapView withRenderDelegate:(id<GMUClusterRendererDelegate>) renderDelegate {
    id<GMUClusterAlgorithm> algorithm = [GMUNonHierarchicalDistanceBasedAlgorithm new];
    id<GMUClusterIconGenerator> clusterIconGenerator = [GMUDefaultClusterIconGenerator new];
    BikeClusterRenderer *renderer = [[BikeClusterRenderer alloc] initWithMapView: mapView clusterIconGenerator:clusterIconGenerator];
    renderer.delegate = renderDelegate;
//    renderer.animatesClusters = false;
//    _currentItems = [NSMutableDictionary new];
    
    self = [super initWithMap:mapView algorithm:algorithm renderer:renderer];
    if (self) {
        
    }
    return self;
}

@end
