//
//  HTNetWorkError.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNetWorkError : NSObject

@property (nonatomic,assign) NSInteger errorCode;
@property (nonatomic,copy) NSString *errorDescription;

@end
