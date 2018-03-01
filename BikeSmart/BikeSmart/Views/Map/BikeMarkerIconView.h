//
//  BikeMarkerIconView.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/16.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BikeModel.h"
#import "BikePieChart.h"

@protocol BikeMarkerIconViewDelegate

- (void)didSelectIcon;

@end

@interface BikeMarkerIconView : UIView
@property (nonatomic, readonly) BikeModel *bikeModel;

- (instancetype)initWithFrame:(CGRect)frame
                withBikeModel:(BikeModel *) bikeMode;

@end
