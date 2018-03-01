//
//  BikeMarkerIconView.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/16.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeMarkerIconView.h"

@interface BikeMarkerIconView()
@property (nonatomic) UIImageView *bikeIconBottomImageView;
@property (nonatomic) CGRect openedFrame, closedFrame;
@property (nonatomic) UIView *detailView, *iconView;
@property (nonatomic) BikePieChart *chartView;
@property (nonatomic) NSString *bikeTopImgName, *bikeBottomImgName;
@property (nonatomic) CGFloat topViewHeightPortion;
@end

@implementation BikeMarkerIconView

- (instancetype)initWithFrame:(CGRect)frame withBikeModel:(BikeModel *) bikeMode
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _closedFrame = frame;
        _openedFrame = CGRectMake(_closedFrame.origin.x, _closedFrame.origin.y, _closedFrame.size.width * 2.5, _closedFrame.size.height);
        _bikeModel = bikeMode;
        
        _topViewHeightPortion = 0.85;
        
        _bikeTopImgName = @"BikeIconTop";
        _bikeBottomImgName = @"BikeIconBottom";
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self setupIconView];
    [self setupIconFooter];
}

- (void)setupIconView {
    _chartView = [[BikePieChart alloc] initWithImage:[UIImage imageNamed:_bikeTopImgName] availableBikes:[_bikeModel getBikeNumber] availableSpaces:[_bikeModel getSpaceNumber]];
    _chartView.translatesAutoresizingMaskIntoConstraints = false;
    
    _iconView = [UIView new];
    _iconView.translatesAutoresizingMaskIntoConstraints = false;
    
    [_iconView addSubview:_chartView];
    
    NSLayoutConstraint *chartHeight = [NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeHeight multiplier:_topViewHeightPortion constant:0];
    NSLayoutConstraint *chartRatio = [NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_chartView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *chartLeadingMargin = [NSLayoutConstraint constraintWithItem:_chartView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    [_iconView addConstraints:@[chartHeight, chartRatio, chartLeadingMargin]];
    
    [self addSubview:_iconView];
}

- (void)setupIconFooter {
    _bikeIconBottomImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_bikeBottomImgName]];
    _bikeIconBottomImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bikeIconBottomImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:_bikeIconBottomImageView];
    
    NSLayoutConstraint *bottomImageHeight = [NSLayoutConstraint constraintWithItem:_bikeIconBottomImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:(1 - _topViewHeightPortion) constant:0];
    NSLayoutConstraint *bottomImageWidth = [NSLayoutConstraint constraintWithItem:_bikeIconBottomImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_bikeIconBottomImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomImageBottom = [NSLayoutConstraint constraintWithItem:_bikeIconBottomImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self addConstraints:@[bottomImageHeight, bottomImageWidth, bottomImageBottom]];
}


@end
