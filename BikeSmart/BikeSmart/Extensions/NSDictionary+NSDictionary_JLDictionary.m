//
//  NSDictionary+NSDictionary_JLDictionary.m
//  BikeSmart
//
//  Created by Jimmy on 2017/10/13.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import "NSDictionary+NSDictionary_JLDictionary.h"

@implementation NSDictionary (NSDictionary_JLDictionary)
+(NSDictionary *)getJSONFromMainBundle:(NSString *)fileName
{
    NSString    *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData      *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
@end
