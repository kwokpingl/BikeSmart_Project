//
//  BikeClusterItem.m
//  BikeSmart
//
//  Created by Jimmy on 2017/12/24.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "BikeClusterItem.h"

@interface BikeClusterItem()
@property (nonatomic) UIImage *markerImage;
@property (nonatomic) CGRect iconSize;
@property (nonatomic) int bikeApproximatePercentage;
@property (nonatomic) NSString *key, *stationName, *percentageKey;
@property (nonatomic) BOOL isFavorite;
@end

@implementation BikeClusterItem

#pragma mark - CLASS METHODs
+ (UIImage *)getIconWithRect:(CGRect)iconSize
                forBikeModel:(BikeModel *) bikeModel {
    
    UIColor *primaryColor = [bikeModel getPrimaryColor];
    UIColor *secondaryColor = [bikeModel getSecondaryColor];
    UIColor *tertiaryColor = [bikeModel getTertiaryColor];
    
    // IconSizes
    CGRect upperIconSize = CGRectMake(0, 0, iconSize.size.width, iconSize.size.width);
    
    // Create a Label
    UILabel *stationNumberLabel = [[UILabel alloc] initWithFrame:upperIconSize];
    UILabel *bikeTypeLabel = [[UILabel alloc] initWithFrame:upperIconSize];
    
    stationNumberLabel.contentMode = UIViewContentModeCenter;
    bikeTypeLabel.contentMode = UIViewContentModeCenter;
    
    UIFont *font = [UIFont JLFontWithStyle:UIFontTextStyleHeadline withFontType:JLFONTTYPES_CAVIARDREAMS_BOLD];
    
    
    NSMutableParagraphStyle *pargraphStyle = [NSMutableParagraphStyle new];
    pargraphStyle.alignment = NSTextAlignmentCenter;
    pargraphStyle.minimumLineHeight = upperIconSize.size.height / 2.0;
    
    NSAttributedString *bikeTypeString = [[NSAttributedString alloc] initWithString:[bikeModel getBikeTypeString] attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:pargraphStyle}];
    
    bikeTypeLabel.attributedText = bikeTypeString;
    [bikeTypeLabel adjustsFontSizeToFitWidth];
    bikeTypeLabel.textColor = secondaryColor;
    
    
    // Create a Images
    UIImage *topImage = nil;
    
    if ([bikeModel isFavorite]) {
        topImage = [UIImage imageNamed:@"FavoriteTop"];
    } else {
        switch ([bikeModel getBikeType]) {
            case EBike_CY:
                topImage = [UIImage imageNamed:@"EBikeIconTop"];
                break;
            default:
                topImage = [UIImage imageNamed:@"BikeIconTop"];
                break;
        }
    }
    
    UIImage *bottomImage = [UIImage imageNamed:@"BikeIconBottom"];
    
    UIImage *bottomColoredImg = [BikeClusterItem getBottomImageWithColor:tertiaryColor inBottomImage:bottomImage];
    
    // Create Path
    CGPoint center = CGPointMake(upperIconSize.size.width / 2.0, upperIconSize.size.height / 2.0);
    CGFloat radius = upperIconSize.size.width / 2.0 - 5;
    
    CGFloat bikeAvailablePercentage = (CGFloat)([bikeModel getBikeNumber]) / (CGFloat)([bikeModel getTotalSpaces]);
    
    CGFloat firstAngle = 90.0;
    CGFloat lastAngle = 360 + 90.0;
    
    CGFloat totalAngle = M_PI * 2.0 - M_PI * (firstAngle - lastAngle)/180.0;
    CGFloat startingAngle = M_PI * firstAngle/180;
    CGFloat firstEndingAngle = startingAngle + totalAngle * bikeAvailablePercentage;
    CGFloat finalEndingAngle = M_PI * lastAngle/180.0;
    
    UIBezierPath *bikeAvailablePath = [UIBezierPath bezierPathWithArcCenter: center radius:radius startAngle:startingAngle endAngle:firstEndingAngle clockwise:true];
    bikeAvailablePath.lineWidth = 5.0;
    bikeAvailablePath.lineJoinStyle = kCGLineJoinRound;
    bikeAvailablePath.lineCapStyle = kCGLineCapRound;
    bikeAvailablePath.flatness = 0;
    
    
    UIBezierPath *spaceAvailablePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startingAngle endAngle:finalEndingAngle clockwise:true];
    spaceAvailablePath.lineWidth = 4.5;
    spaceAvailablePath.lineJoinStyle = kCGLineJoinRound;
    spaceAvailablePath.lineCapStyle = kCGLineCapRound;
    spaceAvailablePath.flatness = 0;
    
    // Create a Final Image
//    UIGraphicsBeginImageContextWithOptions(iconSize.size, false, 1.0);
    
    UIGraphicsImageRenderer *graphicRenderer = [[UIGraphicsImageRenderer alloc] initWithBounds:iconSize];
    
    //draw Images
    UIImage *finalImage = [graphicRenderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
       
        [bottomColoredImg drawInRect:iconSize];
        [topImage drawInRect:upperIconSize];
        
        [[UIColor blackColor] setStroke];
        [spaceAvailablePath stroke];
        
        [primaryColor setStroke];
        [bikeAvailablePath stroke];
        
    }];
    
    
//    graphicRenderer.
    
    
    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (UIImage *) getBottomImageWithColor:(UIColor *)color inBottomImage:(UIImage *)bottomImage {
    // Redraw the BottomImage with Tertiary Color
    UIGraphicsBeginImageContext(bottomImage.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, bottomImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, bottomImage.size.width, bottomImage.size.height);
    CGContextDrawImage(context, rect, bottomImage.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return coloredImg;
}

#pragma mark - INSTANCE METHODs
- (instancetype)initWithPosition:(CLLocationCoordinate2D)position
                       bikeModel:(BikeModel *) bikeModel {
    if ((self = [super init])) {
        _position       = position;
        _key            = [bikeModel getUniqueKey];
        _stationName    = [bikeModel getStationName];
        _percentageKey  = [[bikeModel getBikeTypeString] stringByAppendingFormat:@" %d", [self getBikeAveragePercentage:bikeModel]];
        _isFavorite     = [bikeModel isFavorite];
    }
    
    return self;
}


- (int)getBikeAveragePercentage:(BikeModel *)model {
    CGFloat bikeAvailablePercentage = (CGFloat)([model getBikeNumber]) / (CGFloat)([model getTotalSpaces]);
    
    _bikeApproximatePercentage = (int)(bikeAvailablePercentage * 100);
    
    return _bikeApproximatePercentage;
}

- (NSString *)getClusterItemKey {
    return _percentageKey;
}

- (NSString *)getUniqueKey {
    return _key;
}

- (BOOL)isFavorite {
    return _isFavorite;
}






@end
