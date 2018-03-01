//
//  ContentNavigationBar.m
//  BikeSmart
//
//  Created by Jimmy on 2017/9/17.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "ContentNavigationBar.h"

//static float const defaultHeight = 44.f;

@interface ContentNavigationBar()
{
    CGSize finalSize;
}
@end

@implementation ContentNavigationBar

/**
 Change the Height of NavigationBar

 @param size The original size of NavigationBar
 @return The final NavigationBar Size with DefaultHeight
 */
- (CGSize) sizeThatFits:(CGSize)size {
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height = NavigationBarHeight ;//+ [[UIApplication sharedApplication] statusBarFrame].size.height ;
    finalSize = amendedSize;
    return amendedSize;
}

+ (float) getDefaultHeight {
    return NavigationBarHeight;
}


@end
