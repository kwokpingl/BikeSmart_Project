//
//  NSDictionary+NSDictionary_JLDictionary.h
//  BikeSmart
//
//  Created by Jimmy on 2017/10/13.
//  Copyright © 2017年 Jimmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_JLDictionary)
+ (NSDictionary *) getJSONFromMainBundle:(NSString *) fileName;
@end
