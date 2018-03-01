//
//  MenuCell.m
//  BikeSmart
//
//  Created by Jimmy on 2017/11/30.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell()
//@property (nonatomic) UIImageView
@end

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

#pragma mark - PUBLIC METHODs
- (void)setCellFor:(MenuDestinations) destination {
    
//=    @"Map",
//=    @"Station List",
//=    @"History",
//    @"News",
//    @"Events",
//    @"Policy",
//    @"FAQ",
//    @"Settings",
//    @"Feedback
    NSString *text = @"ERROR";
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    switch (destination) {
        case Menu_Map:
            text = @"Map";
            
            break;
        case Menu_Station_List:
            text = @"Station List";
            break;
        case Menu_History:
            text = @"History";
            break;
        case Menu_FAQ:
            text = @"FAQ";
            break;
        case Menu_Policy:
            text = @"Policy";
            break;
        case Menu_Feedback:
            text = @"Feedback";
            break;
        case Menu_Events:
            text = @"Events";
            break;
        case Menu_Settings:
            text = @"Settings";
            break;
        default:
            break;
    }
    
    
    
//    NSAttributedString *attStr = [NSAttributedString alloc] initWithString:text attributes:<#(nullable NSDictionary<NSString *,id> *)#>
}

@end
