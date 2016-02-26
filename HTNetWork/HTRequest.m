//
//  HTRequest.m
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTRequest.h"

@implementation HTRequest

+ (instancetype)sharedRequestWithMethodType:(RequestMethod)methodType withPath:(NSString *)path withParam:(NSDictionary *)paramDic withConfig:(HTRequestConfig *)config{
    return [[self alloc]initWithMethodType:methodType WithPath:path withParam:paramDic withConfig:config withData:nil];
}

+ (instancetype)sharedRequestWithData:(NSData *)data withPath:(NSString *)path withParam:(NSDictionary *)paramDic withConfig:(HTRequestConfig *)config{
    return [[self alloc]initWithMethodType:RequestMethod_Post WithPath:path withParam:paramDic withConfig:config withData:data];
}

- (instancetype)initWithMethodType:(RequestMethod)methodType WithPath:(NSString *)path withParam:(NSDictionary *)paramDic withConfig:(HTRequestConfig *)config withData:(NSData *)data{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _data = data;
    _methodType = methodType;
    _fullPath = [config.baseUrl stringByAppendingString:path];
    _url = [self genUrlWithPath:path withConfig:config];
    _parameters = paramDic;
    _tag = @"0";
    
    return self;
}

- (NSURL *)genUrlWithPath:(NSString *)path withConfig:(HTRequestConfig *)config{
    if (!path || [path isEqualToString:@""]) {
        return nil;
    }
    
    NSString *baseUrl = config.baseUrl;
    NSString *url = [baseUrl stringByAppendingString:path];
    
    if (config && config.token) {
        url = [url stringByAppendingString:[self getConnector:url]];
        url=[url stringByAppendingFormat:@"%@=%@",@"token",config.token];
    }
    
    if (config && config.sig) {
        url = [url stringByAppendingString:[self getConnector:url]];
        url=[url stringByAppendingFormat:@"%@=%@",@"sig",config.sig];
    }
    
    if (config && config.timestamp) {
        url = [url stringByAppendingString:[self getConnector:url]];
        url=[url stringByAppendingFormat:@"%@=%@",@"timestamp",config.timestamp];
    }
    
    return [NSURL URLWithString:url];
    
}

- (NSString *)getConnector:(NSString *)url{
    NSString *connector = @"&";
    NSRange range = [url rangeOfString:@"?"];
    if (range.location ==NSNotFound){
        connector =  @"?";
    }
    return connector;
}

@end
