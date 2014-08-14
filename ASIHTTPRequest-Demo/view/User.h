//
//  User.h
//  ASIHTTPRequest-Demo
//
//  Created by Jakey on 14-8-14.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userqq;
@property (strong, nonatomic) NSString *useremail;
@property (strong, nonatomic) NSURL *avatarImageURL;


+ (NSURLSessionDataTask *)getUser:(NSDictionary *)paramDic
                        withBlock:(void (^)(User *user, NSError *error))block;
@end
