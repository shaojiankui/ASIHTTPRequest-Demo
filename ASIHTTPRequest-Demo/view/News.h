//
//  News.h
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-8-13.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "BaseModel.h"

@interface News : BaseModel
//返回数据数组 没有进行实体转换
+ (NSURLSessionDataTask *)getNewsDataList:(NSDictionary *)paramDic
                                withBlock:(void (^)(NSArray *list, NSError *error))block;

@end
