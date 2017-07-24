//
//  UIImage+JLImage.m
//  BikeSmart
//
//  Created by Jimmy on 2017/7/8.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "UIImage+JLImage.h"

@implementation UIImage (JLImage)
-(UIImage *)flipImg {
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}
@end
