//
//  HTRequest.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTRequestConfig.h"

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethod_Get = 0,
    RequestMethod_Post,
    RequestMethod_Put,
    RequestMethod_Delete
};

@interface HTRequest : NSObject

@property (readonly,nonatomic,copy) NSURL* url;
@property (readonly,nonatomic,copy) NSString* fullPath;
@property (readonly,nonatomic,copy) NSDictionary* parameters;
@property (readonly,nonatomic,copy) NSData* data;
@property (readonly,nonatomic)RequestMethod methodType;
@property (nonatomic,retain)NSString *tag;

+ (instancetype)sharedRequestWithMethodType:(RequestMethod)methodType withPath:(NSString *)path withParam:(NSDictionary *)paramDic withConfig:(HTRequestConfig *)config;
+ (instancetype)sharedRequestWithData:(NSData *)data withPath:(NSString *)path withParam:(NSDictionary *)paramDic withConfig:(HTRequestConfig *)config;

@end
