//
//  BikePieChart.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/2.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "BikePieChart.h"

@interface BikePieChart()
@property (nonatomic) UIImageView *basicImageView;
@property (nonatomic) UIImage *image;
@property (nonatomic) UILabel *label;
@property (nonatomic) int availableBikes, availableSpaces;
@property (nonatomic) CGFloat availableBikeRatio, pieChartRadius;
@end

@implementation BikePieChart

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
////    CGContextRef ref = UIGraphicsGetCurrentContext();
//    
//    
//    
//    
//}

- (instancetype)initWithImage:(UIImage *) image
               availableBikes:(int) availableBikes
              availableSpaces:(int) availableSpaces {
    self = [super init];
    if (self) {
        _image = image;
        _availableBikes = availableBikes;
        _availableSpaces = availableSpaces;
        _availableBikeRatio = (CGFloat)_availableBikes / (CGFloat)(_availableBikes + _availableSpaces);
        _pieChartRadius = self.frame.size.width / 2.5;
        [self setupUI];
    }
    return self;
}

- (void) setupUI {
    _basicImageView = [UIImageView new];
    _basicImageView.image = _image;
    _basicImageView.contentMode = UIViewContentModeScaleAspectFit;
    _basicImageView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addSubview:_basicImageView];
    
    NSLayoutConstraint *imageViewRatio = [NSLayoutConstraint constraintWithItem:_basicImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_basicImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *imageViewCenterX = [NSLayoutConstraint constraintWithItem:_basicImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *imageViewCenterY = [NSLayoutConstraint constraintWithItem:_basicImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *imageViewWidth = [NSLayoutConstraint constraintWithItem:_basicImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.95 constant:0];
    
    [self addConstraints:@[imageViewRatio, imageViewCenterX, imageViewCenterY, imageViewWidth]];
}

#pragma mark - DRAW 
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bikePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:_pieChartRadius startAngle:-(M_PI / 2.0) endAngle:_availableBikeRatio * M_PI  * 2 - M_PI / 2.0 clockwise:true];
    
    UIBezierPath *spacePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:_pieChartRadius startAngle:_availableBikeRatio * M_PI  * 2 - M_PI / 2.0 endAngle:3.0 * M_PI / 4.0 clockwise:true];
    
    [[UIColor redColor] setStroke];
    [bikePath stroke];
    
    [[UIColor blueColor] setStroke];
    [spacePath stroke];
}

- (void) drawPieChart {
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    UIBezierPath *bikePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:_pieChartRadius startAngle:-(M_PI / 2.0) endAngle:_availableBikeRatio * M_PI  * 2 - M_PI / 2.0 clockwise:true];
    
    UIBezierPath *spacePath = [UIBezierPath bezierPathWithArcCenter:self.center radius:_pieChartRadius startAngle:_availableBikeRatio * M_PI  * 2 - M_PI / 2.0 endAngle:3.0 * M_PI / 4.0 clockwise:true];
    
    [bikePath appendPath:spacePath];
    
    shapeLayer.path = bikePath.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    
}

@end
