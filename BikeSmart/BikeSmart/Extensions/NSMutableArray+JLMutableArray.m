//
//  NSMutableArray+JLMutableArray.m
//  BikeSmart
//
//  Created by Jimmy on 2018/1/26.
//  Copyright © 2018年 Jimmy. All rights reserved.
//

#import "NSMutableArray+JLMutableArray.h"

@implementation NSMutableArray (JLMutableArray)
- (void)swapIndex:(int)indexA withIndex:(int)indexB {
    
    if (indexA + 1 > self.count | indexB + 1 > self.count | indexA < 0 | indexB < 0) {
        NSAssert(true, @"ERROR : INDEX out of bound");
        return;
    }
    
    id objectA = [self objectAtIndex:indexA];
    self[indexA] = self[indexB];
    self[indexB] = objectA;
}
@end
