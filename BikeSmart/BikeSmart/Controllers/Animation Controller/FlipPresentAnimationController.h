//
//  FlipPresentAnimationController.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnimationHelper.h"

typedef enum : NSUInteger {
    Flip,
    EaseIn,
} VCPresentTransitionTypes;

@protocol FlipPresentAnimationControllerDelegate
@required
- (VCPresentTransitionTypes) transitionTypeForPresentAnimation;
@end

@interface FlipPresentAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGRect originFrame;
@property (nonatomic, weak) id <FlipPresentAnimationControllerDelegate> flipDelegate;
- (void) setDuration:(NSTimeInterval) duration;
@end
