//
//  LoadingView.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/12.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+JLView.h"
#import "ImageUtil.h"

@protocol LoadingViewDelegate

- (void)animationCompleted;

@end

@interface LoadingView : UIView

@property (weak, nonatomic) id<LoadingViewDelegate> delegate;

- (void)setLoadingPercentage:(int) loadingPercentage;
@end
