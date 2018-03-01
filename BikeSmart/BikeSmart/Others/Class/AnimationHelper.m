//
//  AnimationHelper.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationHelper.h"


@implementation AnimationHelper

+ (CATransform3D) yRotation:(CGFloat)angle {
    return CATransform3DMakeRotation(angle, 0.0f, 1.0f, 0.0f);
}

+ (void) perspectiveTransformForContainerView:(UIView *)containerView{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    containerView.layer.sublayerTransform = transform;
}

+ (void) printTransform:(CATransform3D) transform {
    NSLog(@"\n%f  %f  %f  %f\n%f    %f   %f  %f\n%f    %f   %f  %f\n%f    %f   %f  %f",
          transform.m11, transform.m12, transform.m13, transform.m14,
          transform.m21, transform.m22, transform.m23, transform.m24,
          transform.m31, transform.m32, transform.m33, transform.m34,
          transform.m41, transform.m42, transform.m43, transform.m44);
}

@end
