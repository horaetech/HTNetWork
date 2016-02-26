//
//  HTRequestConfig.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTRequestConfig : NSObject

@property (nonatomic,retain) NSString *baseUrl;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) NSString *sig;
@property (nonatomic,retain) NSString *timestamp;

@end
