//
//  NavigationButton.m
//  BikeSmart
//
//  Created by Jimmy on 2017/9/29.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "NavigationButton.h"

typedef enum : NSUInteger {
    RoundSpread,
} ViewOpeningAnimation;

@interface NavigationButton()
{
    ViewOpeningAnimation     _animation;
    CGPoint                 _origin;
    __weak UIViewController * _targetViewController;
    __weak UIView           * _targetView;
}

@end


@implementation NavigationButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame
                     animation:(ViewOpeningAnimation) animation
                    targetView:(UIView *) targetView
          targetViewController:(nullable UIViewController *) targetViewController
                        origin:(CGPoint) origin {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _animation  = animation;
        _targetView = targetView;
        _targetViewController = targetViewController;
        _origin     = origin;
        
        [self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


- (void) buttonClicked {
    [self performTransition];
}

- (void) performTransition {
    switch (_animation) {
        case RoundSpread:
            [self roundSpread];
            break;
    }
}

- (void) roundSpread {
    
}


@end
