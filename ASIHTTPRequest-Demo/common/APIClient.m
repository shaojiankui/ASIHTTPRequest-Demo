//
//  APIClient.m
//  AFNetworking-demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import "APIClient.h"
#import "NSDictionary+Json.h"
static dispatch_once_t onceToken;
static APIClient *_sharedClient = nil;

@implementation APIClient
+ (instancetype)sharedClient {
    NSString *baseApiURL = @"http://api.skyfox.org/";  //测试地址

    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:baseApiURL]];
    });
    
    return _sharedClient;
}
- (instancetype)init {
    return [self initWithBaseURL:nil];
}
- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    // Ensure terminal slash for baseURL path, so that NSURL +URLWithString:relativeToURL: works as expected
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    self.baseURL = url;
    
    return self;
}
-(ASIHTTPRequest*)postForm:(NSString*)urlString
                    params:(id)params
              successBlock:(void (^)(ASIHTTPRequest *request,id JSON))success
               failedBlock:(void (^)(ASIHTTPRequest *request,NSError *error))failure{
    
    NSURL *requestUrl = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteURL] ;
    
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    
    NSArray *allkeys=[params allKeys];
    for (int i=0; i<[allkeys count]; i++)
    {
       NSString *key=[allkeys objectAtIndex:i];
       id value=[params objectForKey:key];
       if ([value isKindOfClass:[NSData class]])
        {
           //Data类型
          [request addData:value forKey:key];
        }else
        {
           [request addPostValue:value forKey:key];
        }
    }
    
    [request setCompletionBlock:^{
        //NSString *json = [request responseString];
        NSData *data=[request responseData];
        NSError *error = nil;
        id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"result= %@",result);
        
        success(request, result);
        
    }];
    [request setFailedBlock:^{
        failure(request,request.error);
        
    }];
    [request startAsynchronous];
    return request;

}
-(ASIHTTPRequest*)postJSON:(NSString*)urlString
                    params:(id)params
              successBlock:(void (^)(ASIHTTPRequest *request,id JSON))success
               failedBlock:(void (^)(ASIHTTPRequest *request,NSError *error))failure
{
    NSURL *requestUrl = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteURL] ;


    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    request.requestMethod = @"POST";

    //[request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=utf-8"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];

    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];

    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
     [request setPostBody:tempJsonData];
    
    [request setCompletionBlock:^{
        //NSString *json = [request responseString];
        NSData *data=[request responseData];
        NSError *error = nil;
        id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"result= %@",result);
        
        success(request, result);
        
    }];
    [request setFailedBlock:^{
        failure(request,request.error);
        
    }];
    [request startAsynchronous];
    return request;
 
}

-(ASIHTTPRequest*)getJSON:(NSString*)urlString
                   params:(id)params
             successBlock:(void (^)(ASIHTTPRequest *request,id JSON))success
              failedBlock:(void (^)(ASIHTTPRequest *request,NSError *error))failure
{
    
    NSString *requestString = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteString] ;


    NSMutableString *paramsString = [NSMutableString stringWithCapacity:1];
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [paramsString appendFormat:@"%@=%@",key,obj];
        [paramsString appendString:@"&"];
    }];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@",requestString,paramsString];
    urlStr = [urlStr substringToIndex:urlStr.length-1];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *requestUrl=[NSURL URLWithString:urlStr];

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    [request setRequestMethod:@"GET"];

    
    [request setCompletionBlock:^{
        //NSString *json = [request responseString];
        NSData *data=[request responseData];
        NSError *error = nil;
        id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"result= %@",result);
        
        success(request, result);
        
    }];
    [request setFailedBlock:^{
        failure(request,request.error);
        
    }];
    
    [request startAsynchronous];
     NSLog(@"APIClient GET: %@",[request url]);
    return request;
}


- (ASIHTTPRequest *)DownloadFile:(NSString *)path
                         writeTo:(NSString *)destination
                        fileName:(NSString *)name
                        progress:(void(^)(float progress))progressBlock
                    successBlock:(void(^)(NSString *savePath))success
                     failedBlock:(void(^)(NSError *error))failure
{
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    NSString *filePath = nil;
    if ([destination hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destination,name];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destination,name];
    }
    [request setDownloadDestinationPath:filePath];
    
    __block float downProgress = 0;
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        downProgress += (float)size/total;
        progressBlock(downProgress);
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        success(filePath);
    }];
    
    [request setFailedBlock:^{
        failure(request.error);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"APIClient 下载文件：%@ ",path);
    //NSLog(@"APIClient 保存路径：%@",filePath);
    
    return request;
}
- (ASIHTTPRequest *)ResumeDownloadFile:(NSString *)path
                               writeTo:(NSString *)destination
                              tempPath:(NSString *)tempPath
                              fileName:(NSString *)name
                              progress:(void(^)(float progress))progressBlock
                          successBlock:(void(^)(NSString *savePath))success
                           failedBlock:(void(^)(NSError *error))failure{
    
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    NSString *filePath = nil;
    if ([destination hasSuffix:@"/"]) {
        filePath = [NSString stringWithFormat:@"%@%@",destination,name];
    }
    else
    {
        filePath = [NSString stringWithFormat:@"%@/%@",destination,name];
    }
    
    [request setDownloadDestinationPath:filePath];
    
    NSString *tempForDownPath = nil;
    if ([tempPath hasSuffix:@"/"]) {
        tempForDownPath = [NSString stringWithFormat:@"%@%@.download",tempPath,name];
    }
    else
    {
        tempForDownPath = [NSString stringWithFormat:@"%@/%@.download",tempPath,name];
    }
    
    [request setTemporaryFileDownloadPath:tempForDownPath];
    [request setAllowResumeForFileDownloads:YES];
    
    __block float downProgress = 0;
    downProgress = [[NSUserDefaults standardUserDefaults] floatForKey:@"APIClient_ResumeDOWN_PROGRESS"];
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        
        downProgress += (float)size/total;
        if (downProgress >1.0) {
            downProgress=1.0;
        }
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"APIClient_ResumeDOWN_PROGRESS"];

        progressBlock(downProgress);
        
    }];
    
    [request setCompletionBlock:^{
        downProgress = 0;
        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"APIClient_ResumeDOWN_PROGRESS"];
        success(filePath);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:tempForDownPath]) {
            NSError *error = nil;
           [[NSFileManager defaultManager] removeItemAtPath:tempForDownPath error:&error];
        }
    }];
    
    [request setFailedBlock:^{
        failure(request.error);
    }];
    
    [request startAsynchronous];
    
    //NSLog(@"ASIClient 下载文件：%@ ",path);
   // NSLog(@"ASIClient 保存路径：%@",filePath);
    
    if (downProgress >0 && downProgress) {
        if (downProgress >=1.0) downProgress = 0.9999;
        NSLog(@"APIClient 上次下载已完成：%.2f/100",downProgress*100);
    }
    return request;

}

- (ASIHTTPRequest *)UploadFile:(NSString *)urlString
                          file:(NSString *)filePath
                        forKey:(NSString *)fileKey
                        params:(NSDictionary *)params
                      progress:(void(^)(float progress))progressBlock
                  successBlock:(void (^)(ASIHTTPRequest *request,id JSON))success
                   failedBlock:(void (^)(ASIHTTPRequest *request,NSError *error))failure{
    
    NSURL *requestUrl = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteURL] ;
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    
    [request setFile:filePath forKey:fileKey];
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *error = nil;
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
        success(request,jsonData);
    }];
    
    [request setFailedBlock:^{
        failure(request,[request error]);
    }];
    
    [request startAsynchronous];
    
    NSLog(@"APIClient 文件上传：%@ file=%@ key=%@",urlString,filePath,fileKey);
    NSLog(@"APIClient 文件上传参数：%@",params);
    
    return request;

}
- (ASIHTTPRequest *)UploadData:(NSString *)urlString
                      fileData:(NSData *)fileData
                        forKey:(NSString *)dataKey
                        params:(NSDictionary *)params
                      progress:(void(^)(float progress))progressBlock
                  successBlock:(void (^)(ASIHTTPRequest *request,id JSON))success
                   failedBlock:(void (^)(ASIHTTPRequest *request,NSError *error))failure{
    
    NSURL *requestUrl = [[NSURL URLWithString:urlString relativeToURL:self.baseURL] absoluteURL] ;
    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:requestUrl];
    [request setData:fileData forKey:dataKey];
    if (params.count > 0) {
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request setPostValue:obj forKey:key];
        }];
    }
    
    __block float upProgress = 0;
    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
        upProgress += (float)size/total;
        progressBlock(upProgress);
    }];
    
    [request setCompletionBlock:^{
        upProgress=0;
        NSError *error = nil;
        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&error];
        success(request,jsonData);
    }];
    
    [request setFailedBlock:^{
        failure(request,[request error]);
    }];
    
    [request startAsynchronous];
    
    NSLog(@"APIClient 文件上传：%@ size=%.2f MB  key=%@",urlString,fileData.length/1024.0/1024.0,dataKey);
    NSLog(@"APIClient 文件上传参数：%@",params);
    
    return request;
}
@end
