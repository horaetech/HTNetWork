//
//  HTResponse.m
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/2/1.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTResponse.h"

@implementation HTResponse

+ (HTResponse*)shareResponseWithObject:(id)responseObject{
    return [[self alloc]initWithObject:responseObject];
}

- (instancetype)initWithObject:(id)responseObject{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _object =responseObject;
    _responseObjectDic = [[NSMutableDictionary alloc]init];
    
    return self;
}


- (void)setObject:(id)responseObject withKey:(NSString *)key{
    [_responseObjectDic setObject:responseObject forKey:key];
    _objectDic = _responseObjectDic;
}

- (id)getObjectByKey:(NSString *)key{
    return [_responseObjectDic objectForKey:key];
}

@end
