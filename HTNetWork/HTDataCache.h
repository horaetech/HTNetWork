//
//  HTDataCache.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDataCache : NSObject{
    NSCache *_cache;
}

+ (HTDataCache *)sharedManager;
- (void)cacheDataWithUrl:(NSString *)url withData:(id)jsonData;
- (id)getCacheDataWithUrl:(NSString *)url;

@end
