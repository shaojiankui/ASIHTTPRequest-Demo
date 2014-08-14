//
//  NSString+MD5.h
//  ShippingHelper
//
//  Created by Jack on 13/05/13.
//  Copyright (c) 2013 Shippingchina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)MD5;
- (NSData*)MD5CharData;

+(NSString*)urlEscapeString:(NSString *)unencodedString;
+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;
@end
