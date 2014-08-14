//
//  BaseModel.h
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface BaseModel : Jastor
- (NSString *)json;
- (NSDictionary *)dictionary;
@end
