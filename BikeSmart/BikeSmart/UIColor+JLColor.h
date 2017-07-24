//
//  UIColor+JLColor.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (JLColor)
+ (UIColor *) colorWithHexString: (NSString *) hex;
+ (UIColor *) colorWithHex: (UInt32) hex;
+ (UIColor *) colorWithHex: (UInt32) hex alpha:(CGFloat) alpha;

@property(class, nonatomic, readonly) UIColor * BikeSmart_MainGray;

@end
