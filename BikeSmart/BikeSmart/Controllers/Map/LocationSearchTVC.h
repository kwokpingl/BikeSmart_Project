//
//  LocationSearchTVC.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/29.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "Constants.h"
#import "LocationItemCell.h"

@protocol LocationSearchTVCDelegate

- (void) placeSelected:(MKPlacemark *)placemark;

@end

@interface LocationSearchTVC : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic) MKCoordinateRegion currentRegion;
@property (nonatomic, weak) id<LocationSearchTVCDelegate> locationDelegate;

@end
