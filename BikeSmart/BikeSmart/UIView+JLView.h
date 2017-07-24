//
//  UIView+JLView.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JLView)

- (void) setHeight: (CGFloat)   height;
- (void) setWidth:  (CGFloat)   width;
- (void) offSetBy:  (CGPoint)   origin;

- (void) addConstraintWithFormat:   (NSString *)    format
                           views:   (UIView *)      view, ...;



@end
