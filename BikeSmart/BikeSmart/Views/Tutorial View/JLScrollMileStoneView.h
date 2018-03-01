//
//  ScrollingButtonV.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/18.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLScrollMileStoneButton.h"

@protocol JLScrollMileStoneViewDelegate
- (int)selectedMileStoneIndex;
@end

@interface JLScrollMileStoneView : UIView

@property (nonatomic, weak) id<JLScrollMileStoneViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
            numberOfMileStone:(int) mileStoneNumber
       withSpaceBetweenStones:(CGFloat) space;
@end
