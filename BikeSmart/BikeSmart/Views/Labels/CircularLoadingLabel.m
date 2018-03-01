//
//  CircularLoadingLabel.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "CircularLoadingLabel.h"

#define width   self.frame.size.width
#define height  self.frame.size.height
#define bg      self.backgroundColor

static dispatch_once_t token;

@implementation CircularLoadingLabel
{
    BOOL        _startAnimation;
    CGFloat     _percentage;
    UIColor     *_indicatorColor;
    NSTimer     *_timer;
    int         _animationCounter;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    if (_startAnimation)
    {
        dispatch_once(&token, ^{
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
                _animationCounter ++;
                
                if (_animationCounter > 360)
                {
                    _animationCounter -= 360;
                }
                
                if (_animationCounter % 360 >= 6)
                {
                    [self redrawCircle];
                }
                
            }];
            
            [_timer fire];
        });
        
    }
    else
    {
        [self redrawCircle];
    }
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // do something
        _startAnimation = false;
        _animationCounter = 0;
        token = 0;
    }
    
    return self;
}

// Calling this method will not show progress bar instead a continuous rotating arc will be shown
- (void) startAnimation {
    _startAnimation = true;
    
    // to notify the system that your view’s contents need to be redrawn. This method makes a note of the request and returns immediately. The view is not actually redrawn until the next drawing cycle, at which point all invalidated views are updated.
    
    [self setNeedsDisplay];
}

- (void) setPercentage:(CGFloat) percentage {
    _percentage = percentage;
    [self setNeedsDisplay];
}

- (void) setIndicatorColor:(UIColor *) indicatorColor {
    _indicatorColor = indicatorColor;
}

- (void) redrawCircle {
    
    CGContextRef circle = UIGraphicsGetCurrentContext();
    
    CGFloat radius = 0;
    
    if (width >= height)
    {
        radius = height/2;
    }
    else
    {
        radius = width/2;
    }
    
    if (_startAnimation)
    {
        CGContextAddArc(circle, width/2, height/2, radius, -M_PI_2, M_PI * _animationCounter / 360, 0);
        [_indicatorColor set];
        CGContextSetLineWidth(circle, 5);
        CGContextStrokePath(circle);
    }
    else
    {
        CGContextAddArc(circle, width/2, height/2, radius, -M_PI_2, 2 * M_PI * _percentage/100, 0);
        [_indicatorColor set];
        CGContextSetLineWidth(circle, 5);
        CGContextStrokePath(circle);
    }
    
}

- (void)stopAnimation {
    [_timer invalidate];
}

@end
