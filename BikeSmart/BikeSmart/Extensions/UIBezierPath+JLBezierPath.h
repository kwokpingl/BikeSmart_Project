//
//  UIBezierPath+JLBezierPath.h
//  BikeSmart
//
//  Created by Jimmy on 2018/1/17.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIBezierPath (JLBezierPath)


+ (void) ApplyCenteredPathTransform: (UIBezierPath *)path
                          Transform: (CGAffineTransform) transform;

+ (void) OffsetPath: (UIBezierPath *) path offSet:(CGSize) offset;

+ (CGPoint) RectGetCenter:(CGRect)rect;

+ (CGPoint) PathBoundingCenter:(UIBezierPath *)path;

+ (CGRect) PathBoundingBox:(UIBezierPath *)path;

+ (void) MirrorPathVertically:(UIBezierPath *)path;

+ (UIBezierPath *)bezierPathFromString:(NSString *)string
                                  font:(UIFont *)font;

@end
