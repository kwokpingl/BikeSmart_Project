//
//  UIBezierPath+JLBezierPath.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/17.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "UIBezierPath+JLBezierPath.h"

@implementation UIBezierPath (JLBezierPath)

+ (UIBezierPath *)bezierPathFromString:(NSString *)string
                                  font:(UIFont *)font {
    // Initiate UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (!string.length) return path;
    
    // Create Font Ref
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
    if (fontRef == nil) {
        NSLog(@"Error retrieving CTFontRef from UIFont");
        return nil;
    }
    
    // Create glyphs (that is, individual letter shapes)
    CGGlyph *glyphs = malloc(sizeof(CGGlyph) *string.length);
    const unichar *chars = (const unichar *)[string cStringUsingEncoding:NSUnicodeStringEncoding];
    BOOL success = CTFontGetGlyphsForCharacters(fontRef, chars, glyphs, string.length);
    
    if (!success) {
        NSLog(@"Error retrieving string glyphs");
        CFRelease(fontRef);
        free(glyphs);
        return nil;
    }
    
    for (int i = 0; i < string.length; i++) {
        // Glyphs to CGPath
        CGGlyph glyph = glyphs[i];
        CGPathRef pathRef = CTFontCreatePathForGlyph(fontRef, glyph, NULL);
        
        // Append Path
        [path appendPath:[UIBezierPath bezierPathWithCGPath:pathRef]];
        
        // Offset by Size
        CGSize size = [[string substringWithRange:NSMakeRange(i, 1)] sizeWithAttributes:@{NSFontAttributeName:font}];
     
        [UIBezierPath OffsetPath:path offSet:CGSizeMake(-size.width, 0)];
        
        
    }
    
    // Clean-Up
    free(glyphs);
    CFRelease(fontRef);
    
    // Return the path in UIKit Coordinate
    [UIBezierPath MirrorPathVertically:path];
    return path;
}

// Offset a path
+ (void) OffsetPath: (UIBezierPath *) path offSet:(CGSize) offset
{
    CGAffineTransform t =
    CGAffineTransformMakeTranslation(
                                     offset.width, offset.height);
    [UIBezierPath ApplyCenteredPathTransform:path Transform:t];
}

// Translate path’s origin to its center before applying the transform
+ (void) ApplyCenteredPathTransform: (UIBezierPath *)path
                          Transform: (CGAffineTransform) transform
{
    CGPoint center = [UIBezierPath PathBoundingCenter:path];
    CGAffineTransform t = CGAffineTransformIdentity;
    t = CGAffineTransformTranslate(t, center.x, center.y);
    t = CGAffineTransformConcat(transform, t);
    t = CGAffineTransformTranslate(t, -center.x, -center.y);
    [path applyTransform:t];
}

// Return the calculated center point
+ (CGPoint) PathBoundingCenter:(UIBezierPath *)path
{
    return [UIBezierPath RectGetCenter:[UIBezierPath
                                        PathBoundingBox:path]];
}

// Retrieving a Rectangle Center
+ (CGPoint) RectGetCenter:(CGRect) rect
{
    return CGPointMake(CGRectGetMidX(rect),
                       CGRectGetMidY(rect));
}

// Return calculated bounds
+ (CGRect) PathBoundingBox:(UIBezierPath *)path
{
    return CGPathGetPathBoundingBox(path.CGPath);
}

// Flip vertically
+ (void) MirrorPathVertically:(UIBezierPath *)path
{
    CGAffineTransform t = CGAffineTransformMakeScale(1, -1);
    [UIBezierPath ApplyCenteredPathTransform:path Transform:t];
}

@end
