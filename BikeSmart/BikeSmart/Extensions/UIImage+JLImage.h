//
//  UIImage+JLImage.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/8.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JLImage)
- (UIImage *) flipImg;
- (UIImage *) scaleTo:(CGFloat) scale;
- (UIImage *) resizedTo:(CGSize) size;
@end
