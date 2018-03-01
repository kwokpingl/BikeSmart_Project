//
//  MenuCell.h
//  BikeSmart
//
//  Created by Jimmy on 2017/11/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>


//@[@"Map", @"Station List", @"History", @"Policy", @"FAQ", @"Feedback"];
typedef NS_ENUM(NSUInteger, MenuDestinations) {
    Menu_Map,
    Menu_Station_List,
    Menu_History,
    Menu_Policy,
    Menu_FAQ,
    Menu_Feedback,
    Menu_Events,
    Menu_Settings,
};

@interface MenuCell : UITableViewCell

@end
