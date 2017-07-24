//
//  UIColor+JLColor.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIColor+JLColor.h"

@implementation UIColor (JLColor)


/**
 Convert hex String to UIColor

 @param hex hexidecimal in string (example: @"#123456")
 @return UIColor *
 */
+ (UIColor *) colorWithHexString: (NSString *) hex {
    const char * cStr = [hex cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr + 1, NULL, 16);
    /*
     Convert from String to Long
     1. str: 
     C-string beginning with the representation of an integral number.
     
     2. endptr
     Reference to an object of type char*, whose value is set by the function to the next character in str after the numerical value.
     This parameter can also be a null pointer, in which case it is not used.
     
     3. base
     Numerical base (radix) that determines the valid characters and their interpretation.
     If this is 0, the base used is determined by the format in the sequence (see above).
     
     */
    return [UIColor colorWithHex:(UInt32)x];
}


/**
 Convert hex UInt32 to UIColor

 @param hex hexidecimal (example: 0x123456)
 @return UIColor *
 */
+ (UIColor *)colorWithHex:(UInt32)hex {
    unsigned char r, g, b;
    b = hex & 0xFF;
    g = (hex >> 8) & 0xFF;
    r = (hex >> 16) & 0xFF;
    return [UIColor colorWithRed:(float) r/255.0f green:(float) g/255.0f blue:(float) b/255.0f alpha:1];
}

+ (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    unsigned char r, g, b;
    b = hex & 0xFF;
    g = (hex >> 8) & 0xFF;
    r = (hex >> 16) & 0xFF;
        
    return [UIColor colorWithRed:(float) r/255.0f green:(float) g/255.0f blue:(float) b/255.0f alpha:alpha];
}

+ (UIColor *) BikeSmart_MainGray {
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:205.0/255.0 alpha:1.0];
}

@end
