//
//  NSString+Dictionary.m
//  vw-service
//
//  Created by Jakey on 14-6-13.
//  Copyright (c) 2014年 jakey. All rights reserved.
//

#import "NSString+Dictionary.h"

@implementation NSString (Dictionary)

-(NSDictionary *) JsonToDictionary{
    NSError *errorJson;
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    return ret;
}

@end
