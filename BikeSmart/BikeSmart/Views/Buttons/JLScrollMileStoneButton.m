//
//  ScrollButtonMileStone.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "JLScrollMileStoneButton.h"

@interface JLScrollMileStoneButton()

IBInspectable
@property (nonatomic) UIEdgeInsets insets;

@end

@implementation JLScrollMileStoneButton

- (void)layerWillDraw:(CALayer *)layer {
    [super layerWillDraw:layer];
//    _imgV.frame = UIEdgeInsetsInsetRect(self.bounds, _insets);;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundPath = [UIBezierPath new];
    
    CGFloat midX = self.bounds.size.width/2.0;
    CGFloat midY = self.bounds.size.height/2.0;
    
    CGFloat radius = (self.bounds.size.height > self.bounds.size.width)? self.bounds.size.width/2.0 - _insets.left : self.bounds.size.height/2.0 - _insets.top;
    
    [roundPath addArcWithCenter: CGPointMake(midX, midY) radius:radius startAngle:0 endAngle:M_PI * 2.0 clockwise:true];
    
    roundPath.lineWidth = 1.0;
    
    // Draw the Circle with White Border & Fill with Black Color
    
    
    UIColor *border = [UIColor whiteColor];
    UIColor *fill   = [UIColor blackColor];
    
    if (_borderColorDeselected != nil) {
        border = _borderColorDeselected;
    }
    
    if (_fillColorDeselected != nil) {
        fill = _fillColorDeselected;
    }
    
    if (self.selected) {
        border = [UIColor blackColor];
        fill = [UIColor whiteColor];
        
        if (_borderColorSelected != nil) {
            border = _borderColorSelected;
        }
        
        if (_fillColorSelected != nil) {
            fill = _fillColorSelected;
        }
    }
    
    [border setStroke];
    [fill setFill];
    
    [roundPath stroke];
    [roundPath fill];
}

//- (instancetype)initWithCoder:(NSCoder *)aDecoder

- (instancetype)initWithFrame:(CGRect)frame
                       insets:(UIEdgeInsets) insets {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _insets = insets;
        
        [self setImageEdgeInsets:insets];
        [self setBackgroundImage:[UIImage imageNamed:@"MainIconBlack"]
                        forState:UIControlStateNormal];
        [self setContentMode:UIViewContentModeScaleAspectFit];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}


@end
