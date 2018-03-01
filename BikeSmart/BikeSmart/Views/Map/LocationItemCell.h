//
//  LocationItemCell.h
//  BikeSmart
//
//  Created by Jimmy on 2017/12/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "UIFont+JLFont.h"
#import "UIFontDescriptor+JLFontDescriptor.h"

@interface LocationItemCell : UITableViewCell
- (void) setMapItem:(MKMapItem *)mapItem;
- (MKPlacemark *) returnPlacemark;
@end
