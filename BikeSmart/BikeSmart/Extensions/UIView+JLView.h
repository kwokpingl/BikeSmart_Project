//
//  UIView+JLView.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/3.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JLView)

typedef enum : NSUInteger {
    ChangeAlongX,
    ChangeAlongY,
} ChangeAlong;

- (void) setHeight:         (CGFloat)   height;
- (void) setWidth:          (CGFloat)   width;
- (void) offSetBy:          (CGPoint)   origin;
- (void) offSetXBy:         (CGFloat)   x;
- (void) offSetYBy:         (CGFloat)   y;
- (void) boundsOffSetBy:    (CGPoint)   origin;

- (void) addConstraintWithFormat:   (NSString *)    format
                           views:   (UIView *)      view, ...;
#pragma mark - SIZE
- (void)changeSizeByPercent:(CGFloat) percentage
            changeSizeAlong:(ChangeAlong) along;
- (void)changeSizeTo:(CGSize) size;

- (void)shiftTo:(CGFloat)margin
          along:(ChangeAlong)along;

#pragma mark - FETCH DETAIL
- (UIImage *)getViewAsImage;
@end
