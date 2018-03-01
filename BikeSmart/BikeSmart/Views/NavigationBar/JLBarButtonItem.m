//
//  JLBarButtonItem.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/11.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "JLBarButtonItem.h"

@implementation JLBarButtonItem
- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action resizedToSize:(CGSize) size {
    
    UIImage *newImg = [image resizedTo:size];
    
    self = [super initWithImage:newImg style:style target:target action:action];
    
    if (self) {
        
    }
    
    return self;
}
@end
