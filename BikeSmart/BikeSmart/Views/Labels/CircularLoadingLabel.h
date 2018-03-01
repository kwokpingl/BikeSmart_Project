//
//  CircularLoadingLabel.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularLoadingLabel : UILabel
- (void) startAnimation;
- (void) stopAnimation;
- (void) setPercentage:(CGFloat) percentage;
- (void) setIndicatorColor:(UIColor *) indicatorColor;
@end
