//
//  UIImage+JLImage.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/8.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIImage+JLImage.h"

@implementation UIImage (JLImage)
-(UIImage *)flipImg
{
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)scaleTo:(CGFloat) scale
{
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    
    // create drawing context
    // 0.0 -> pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution). Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0f);
    
    // draw
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    // capture the final image
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

- (UIImage *) resizedTo:(CGSize) size {
    CGFloat height  = self.size.height;
    CGFloat width   = self.size.width;
    CGFloat ratio   = self.size.height / self.size.width;
    
    if (height > width) {
        height  = size.height;
        width   = height / ratio;
    } else {
        width   = size.width;
        height  = width * ratio;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), false, 0.0f);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

@end
