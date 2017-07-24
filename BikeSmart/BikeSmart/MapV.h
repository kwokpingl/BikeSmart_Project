//
//  MapV.h
//  BikeSmart
//
//  Created by Jimmy on 2017/7/4.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+JLColor.h"
#import "UIView+JLView.h"
#import "MapInfoBtn.h"

@protocol MapVDelegate

- (void) mapV:(UIView *) mapV presentAlert:(UIAlertController *) alert;

@end


@interface MapV : UIView <CLLocationManagerDelegate>
@property (nonatomic, weak) id<MapVDelegate> delegate;
@end
