//
//  News.m
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-8-13.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "News.h"
#import "APIClient.h"
@implementation News
+ (ASIHTTPRequest *)getNewsDataList:(NSDictionary *)paramDic
                                withBlock:(void (^)(NSArray *list, NSError *error))block{
    
   return [[APIClient sharedClient]postJSON:@"api-test.php" params:paramDic successBlock:^(ASIHTTPRequest *request, id JSON) {
        NSDictionary *result = JSON;
        NSLog(@"result =%@",result);
        NSArray *list = [result objectForKey:@"success"];
        if ([list isKindOfClass:[NSArray class]] && block) {
            block(list, nil);
        }

        
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];

}
@end
