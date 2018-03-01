//
//  LocationItemCell.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "LocationItemCell.h"

@interface LocationItemCell()
@property (nonatomic) MKMapItem *mapItem;
@property (nonatomic) MKPlacemark *placeMark;
@property (nonatomic) NSAttributedString *locationName, *locationAddress;
@end

@implementation LocationItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setMapItem:(MKMapItem *)mapItem {
    
    _mapItem = mapItem;
    
    _placeMark = _mapItem.placemark;
    
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleTitle1 withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    
    NSString *name = [NSString stringWithFormat:@"%@\n", _placeMark.name];
    
    _locationName = [[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:font}];
    
    UIFont *secondFont = [UIFont JLFontWithStyle:UIFontTextStyleBody withFontType:JLFONTTYPES_CAVIARDREAMS_NORMAL];
    _locationAddress = [[NSAttributedString alloc] initWithString:_placeMark.title attributes:@{NSFontAttributeName:secondFont}];
    
    self.textLabel.numberOfLines = 0;
    NSMutableAttributedString *str = [NSMutableAttributedString new];
    [str appendAttributedString:_locationName];
    [str appendAttributedString:_locationAddress];
    
    self.textLabel.attributedText = str;
}

- (MKPlacemark *) returnPlacemark {
    return _placeMark;
}

@end
