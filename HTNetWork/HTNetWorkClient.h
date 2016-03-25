//
//  HTNetWorkClient.h
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "HTRequest.h"
#import "HTNetWorkError.h"
#import "HTResponse.h"
#import "HTDataCache.h"

typedef NS_ENUM(NSInteger, DataType) {
    DataType_Image = 0,
    DataType_Audio,
    DataType_Viedo
};

@protocol HTRequestDelegate <NSObject>

@optional

- (void)requestStart;
- (void)requestProgress:(NSProgress *)progress withTag:(NSString *)tag;
- (void)requestFinished:(id)response;
- (void)requestFailed:(HTNetWorkError *)request;

@end

typedef void (^HITResponseObject)(HTResponse *response);
typedef void (^HITResponseProgress)(NSProgress *progress, NSString *tag);
typedef void (^HITResponseError)(HTNetWorkError* responseError);

@interface HTNetWorkClient : NSObject{
    AFHTTPSessionManager *_requestManager;
    NSInteger _bacthRequestCount;
    HTResponse *_batchResponse;
    NSMutableDictionary *_batchRequest;
}

@property (nonatomic,weak) id<HTRequestDelegate> delegate;
@property (nonatomic)BOOL defaultCheckMessage;
@property (nonatomic)BOOL defaultUseCache;

+ (instancetype)sharedClient;

- (void)startAsynchronous:(HTRequest *)request;
- (void)startAsynchronous:(HTRequest*)request
               onProgress:(HITResponseProgress)progressBlock
               onResponse:(HITResponseObject)responseBlock
                  onError:(HITResponseError)errorBlock;

- (void)startAsynchronousWithBatchRequest:(NSArray *)batchRequest;
- (void)startAsynchronousWithBatchRequest:(NSArray *)batchRequest
               onProgress:(HITResponseProgress)progressBlock
               onResponse:(HITResponseObject)responseBlock
                  onError:(HITResponseError)errorBlock;

- (void)startUploadData:(HTRequest *)request withDataType:(DataType)dataType;
- (void)startUploadData:(HTRequest *)request withDataType:(DataType)dataType
             onProgress:(HITResponseProgress)progressBlock
             onResponse:(HITResponseObject)responseBlock
                onError:(HITResponseError)errorBlock;

- (void)cancel;
- (id)getCacheData:(HTRequest *)request;

@end
