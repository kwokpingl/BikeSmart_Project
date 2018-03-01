//
//  BikeCluster.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/15.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "BikeCluster.h"

@implementation BikeCluster

+(UIImage *) getClusterImageWithItems:(int) numberOfItem
                             forModel:(__weak BikeModel *) bikeModel
                             withSize:(CGSize) size {
    
   
    
    
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleHeadline withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    
//    NSAttributedString *bikeDistrictString = [[NSAttributedString alloc] initWithString:[bikeModel getStationDistrict] attributes:@{NSFon tAttributeName:font}];
    
//    UIBezierPath *districtStringPath = [UIBezierPath bezierPathFromString:[bikeModel getStationDistrict] font:font];
    
    NSString *districtStr = [bikeModel getStationDistrict];
    
    CGRect destinateRect = (CGRect){CGPointMake(5, 5), CGSizeMake(size.width * 0.8, size.height * 0.7)};
    
    UIBezierPath *outterRectPath = [UIBezierPath bezierPathWithRoundedRect:destinateRect cornerRadius:5.0];
    
    UIBezierPath *innerRectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(destinateRect, 4, 4) cornerRadius:5];
    
    CGSize badgerSize = (CGSize){size.width * 0.25, size.width * 0.25};
    
    CGPoint badgerOrigin = (CGPoint){destinateRect.size.width - badgerSize.width, 0};
    
    CGRect badgerRect = (CGRect){badgerOrigin, badgerSize};
    
    CGPoint badgerCenter = (CGPoint){size.width, 0};
    
    UIBezierPath *badgerPath = [UIBezierPath bezierPathWithOvalInRect:badgerRect];
    
    NSString *badgerStr = [NSString stringWithFormat:@"%d", numberOfItem];
    
    UIGraphicsBeginImageContextWithOptions(size, false, 1.0);
    
    [UIColor.blackColor setStroke];
    
    [[bikeModel getPrimaryColor] setFill];
    [outterRectPath stroke];
    [outterRectPath fill];
    
    [UIColor.whiteColor setFill];
    [innerRectPath stroke];
    [innerRectPath fill];
    
    [[bikeModel getTertiaryColor] setStroke];
    [districtStr drawInRect: CGRectInset(destinateRect, 4, 4)withAttributes:@{NSFontAttributeName:font}];
//    [districtStringPath stroke];
//    [districtStringPath fill];
    
    [badgerPath stroke];
    [badgerPath fill];
    
    [badgerStr drawAtPoint:badgerCenter withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    UIImage *clusterIcon = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return clusterIcon;
}

+(UIView *)getClusterViewWithItems:(int) numberOfItem
                           forModel:(__weak BikeModel *) bikeModel
                          withSize:(CGSize) size {
    
    UIView *outterV = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, size}];
    
    CGSize mainVSize = CGSizeMake(outterV.frame.size.width * 0.8, outterV.frame.size.height * 0.9);
    CGPoint mainVOrigin = CGPointMake(5, outterV.frame.size.height - mainVSize.height);
    
    UIView *mainV = [[UIView alloc] initWithFrame:(CGRect){mainVOrigin, mainVSize}];
    
    mainV.backgroundColor = [bikeModel getPrimaryColor];
    
    UILabel *districtLabel = [UILabel new];
    districtLabel.frame = (CGRect){CGPointMake(5, 5), CGRectInset(mainV.frame, 5, 5).size};
    districtLabel.backgroundColor = [UIColor whiteColor];
    
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleHeadline withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSAttributedString *bikeDistrictString = [[NSAttributedString alloc] initWithString:[bikeModel getStationDistrict] attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle}];
    
    districtLabel.attributedText = bikeDistrictString;
    districtLabel.adjustsFontSizeToFitWidth = true;
    districtLabel.layer.masksToBounds = true;
    districtLabel.layer.cornerRadius = 5;
    [mainV addSubview:districtLabel];
    
    [outterV addSubview:mainV];
    
    return outterV;
}

@end
