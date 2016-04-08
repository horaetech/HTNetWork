//
//  HTDataCache.m
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTDataCache.h"

@implementation HTDataCache

+ (HTDataCache *)sharedManager{
    static HTDataCache *sharedHTDataCacheInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHTDataCacheInstance = [[self alloc] initWithCache];
        
    });
    return sharedHTDataCacheInstance;
}

- (instancetype)initWithCache{
    self = [super init];
    if (!self) {
        return nil;
    }
    _cache =[[NSCache alloc]init];
    return self;
}

- (void)cacheDataWithUrl:(NSString *)url withData:(id)jsonData{
    if (jsonData) {
        [_cache setObject:jsonData forKey:url];
    }
}

- (id)getCacheDataWithUrl:(NSString *)url{
    return [_cache objectForKey:url];
}

@end
