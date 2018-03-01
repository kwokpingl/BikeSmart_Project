//
//  BikeMarkerAvailableIndicatorView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/24.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeMarkerAvailableIndicatorView.h"

@interface BikeMarkerAvailableIndicatorView()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) BikeModel *bikeModel;
@property (nonatomic) int bikeAvailable, spaceAvailable;
@property (nonatomic) NSString *bikeStationNumber;
@property (nonatomic) BikeTypes bikeType;
@end

@implementation BikeMarkerAvailableIndicatorView

- (instancetype)initWithFrame:(CGRect)frame bikeModel:(BikeModel *) model
{
    self = [super initWithFrame:frame];
    if (self) {
        _bikeModel = model;
        _imageView = [UIImageView new];
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        _imageView.image = [UIImage imageNamed:[_bikeModel getImageName]];
        [self addSubview:_imageView];
        
        _imageView.frame = self.bounds;
        
        _bikeAvailable = [_bikeModel getBikeNumber];
        _spaceAvailable = [_bikeModel getSpaceNumber];
    }
    return self;
}

- (void)drawCircle {
//    UIBezierPath 
}

@end
