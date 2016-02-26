//
//  HTResponse.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/2/1.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTResponse : NSObject{
    NSMutableDictionary *_responseObjectDic;
}

@property (readonly,nonatomic,strong)id object;
@property (readonly,nonatomic,strong)NSDictionary *objectDic;

+ (HTResponse*)shareResponseWithObject:(id)responseObject;
- (void)setObject:(id)responseObject withKey:(NSString *)key;
- (id)getObjectByKey:(NSString *)key;

@end
