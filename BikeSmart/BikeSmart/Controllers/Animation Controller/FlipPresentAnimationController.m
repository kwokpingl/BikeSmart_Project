//
//  FlipPresentAnimationController.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "FlipPresentAnimationController.h"

@implementation FlipPresentAnimationController
{
    NSTimeInterval _duration;
    VCPresentTransitionTypes _transitionType;
}

- (void) setDuration:(NSTimeInterval) duration{
    _duration = duration;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (!_duration)
    {
        _duration = 1.2;
    }
    
    return _duration;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    _transitionType = [_flipDelegate transitionTypeForPresentAnimation];
    
    switch (_transitionType) {
        case Flip:
            [self rotatingTransformTransition:transitionContext];
            break;
        case EaseIn:
            [self easeInTransition:transitionContext];
            break;
    }
    
}

- (void) rotatingTransformTransition:(id<UIViewControllerContextTransitioning>) transitionContext{
    UIViewController *fromVC    = [transitionContext
                                   viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC      = [transitionContext
                                   viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView  *containerView      = transitionContext.containerView;
    
    // return if both are nil
    if (!(fromVC && toVC))
    {
        return;
    }
    
    if (CGRectIsNull(_originFrame))
    {
        _originFrame = CGRectZero;
    }
    
    CGRect initialFrame = _originFrame;
    CGRect finalFrame   = [transitionContext finalFrameForViewController:toVC];
    
    UIView *snapshot = [toVC.view snapshotViewAfterScreenUpdates:true];
    snapshot.frame = initialFrame;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapshot];
    [toVC.view setHidden:true];
    
    [AnimationHelper perspectiveTransformForContainerView:containerView];
    snapshot.layer.transform = [AnimationHelper yRotation:M_PI_2];
    
    double duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0/3.0 animations:^{
            [fromVC.view.layer setTransform:[AnimationHelper yRotation:-M_PI_2]];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:1.0/3.0 relativeDuration:1.0/3.0 animations:^{
            snapshot.layer.transform = [AnimationHelper yRotation:0.0];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:2.0/3.0 relativeDuration:1.0/3.0 animations:^{
            snapshot.frame = finalFrame;
        }];
        
    } completion:^(BOOL finished) {
        [toVC.view setHidden:false];
        fromVC.view.layer.transform = [AnimationHelper yRotation:0.0];
        [snapshot removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)easeInTransition:(id<UIViewControllerContextTransitioning>) transitionContext {
    UIViewController *fromVC    = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC      = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView  *containerView      = transitionContext.containerView;
    
    // return if both are nil
    if (!(fromVC && toVC))
    {
        return;
    }
    
    [containerView addSubview:toVC.view];
    
    [toVC.view setAlpha:0];
    
    CGFloat duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration animations:^{
        [toVC.view setAlpha:1];
        [fromVC.view setAlpha:0];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
