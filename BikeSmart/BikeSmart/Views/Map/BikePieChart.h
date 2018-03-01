//
//  BikePieChart.h
//  BikeSmart
//
//  Created by Jimmy on 2018/1/2.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BikePieChart : UIView

- (instancetype)initWithImage:(UIImage *) image
               availableBikes:(int) availableBikes
              availableSpaces:(int) availableSpaces;

@end
