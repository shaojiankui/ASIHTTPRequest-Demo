//
//  User.m
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-8-14.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "User.h"
#import "APIClient.h"
#import "NSDictionary+Json.h"
#import "NSString+Dictionary.h"
@implementation User
+ (ASIHTTPRequest *)getUser:(NSDictionary *)paramDic withBlock:(void (^)(User *user, NSError *error))block{
    
    return [[APIClient sharedClient]postJSON:@"api-test.php" params:paramDic successBlock:^(ASIHTTPRequest *request, id JSON) {
        NSDictionary *result = JSON;
        
        User *user =  [User objectFromDictionary:result];

        block(user, nil);
        
        
    } failedBlock:^(ASIHTTPRequest *request, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end