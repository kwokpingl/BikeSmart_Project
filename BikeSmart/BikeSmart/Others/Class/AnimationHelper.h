//
//  AnimationHelper.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/26.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationHelper : NSObject

+ (CATransform3D) yRotation:(double)angle;
+ (void) perspectiveTransformForContainerView:(UIView *)containerView;
+ (void) printTransform:(CATransform3D) transform;
@end
