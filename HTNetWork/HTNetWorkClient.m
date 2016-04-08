//
//  HTNetWorkClient.m
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTNetWorkClient.h"

@implementation HTNetWorkClient

#pragma mark - life cycle
+ (instancetype)sharedClient{
    return [[self alloc]init];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _requestManager =[AFHTTPSessionManager manager];
    [_requestManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    _requestManager.requestSerializer.timeoutInterval = 30.f;
    [_requestManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    _requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    _bacthRequestCount = 1;
    _batchResponse = nil;
    _defaultCheckMessage = YES;
    _defaultUseCache = YES;
    _batchRequest = [[NSMutableDictionary alloc]init];
    
    return self;
}

#pragma mark - instance method

- (void)startAsynchronous:(HTRequest *)request{
    if([self.delegate respondsToSelector:@selector(requestStart)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate requestStart];
        });
    }
    
    if (request.methodType ==RequestMethod_Get) {
        NSURLSessionDataTask *task =[_requestManager GET:[request.url absoluteString] parameters:nil  progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         HTRequest *curRequest = [self getCurrentRequest:task];
                         [self onResponseWithFinishBlock:nil withErrorBlock:nil
                                      withResponseObject:responseObject withRequest:curRequest];
                         [self removeCurrentRequest:task];
                         
                     } failure:^(NSURLSessionTask *operation, NSError *error) {
                         HTRequest *curRequest = [self getCurrentRequest:task];
                         [self onErrorwithBlock:nil withRequest:curRequest];
                         [self removeCurrentRequest:task];
                     }];
        [self addCurrentRequest:request withTask:task];
        
    }else if(request.methodType ==RequestMethod_Post){
        NSURLSessionDataTask *task =[_requestManager POST:[request.url absoluteString] parameters:request.parameters
                      progress:^(NSProgress *progress){
                          if ([self.delegate respondsToSelector:@selector(requestProgress:withTag:)]){
                              [self.delegate requestProgress:progress withTag:request.tag];
                          }
                      } success:^(NSURLSessionTask *task, id responseObject) {
                          HTRequest *curRequest = [self getCurrentRequest:task];
                          [self onResponseWithFinishBlock:nil withErrorBlock:nil
                                       withResponseObject:responseObject withRequest:curRequest];
                          [self removeCurrentRequest:task];
                          
                      } failure:^(NSURLSessionTask *operation, NSError *error) {
                          HTRequest *curRequest = [self getCurrentRequest:task];
                          [self onErrorwithBlock:nil withRequest:curRequest];
                          [self removeCurrentRequest:task];
                      }];
        [self addCurrentRequest:request withTask:task];
    }
    
    
}

- (void)startAsynchronous:(HTRequest*)request
               onProgress:(HITResponseProgress)progressBlock
                     onResponse:(HITResponseObject)responseBlock
                        onError:(HITResponseError)errorBlock{
    if (request.methodType ==RequestMethod_Get) {
        NSURLSessionDataTask *task = [_requestManager GET:[request.url absoluteString] parameters:nil
                    progress:^(NSProgress *progress){
                        if (progressBlock) {
                            progressBlock(progress,request.tag);
                        }
                    } success:^(NSURLSessionTask *task, id responseObject) {
                         HTRequest *curRequest = [self getCurrentRequest:task];
                         [self onResponseWithFinishBlock:responseBlock withErrorBlock:errorBlock withResponseObject:responseObject withRequest:curRequest];
                        [self removeCurrentRequest:task];
                         
                    } failure:^(NSURLSessionTask *operation, NSError *error) {
                        HTRequest *curRequest = [self getCurrentRequest:task];
                        [self onErrorwithBlock:errorBlock withRequest:curRequest];
                        [self removeCurrentRequest:task];
                    }];
        [self addCurrentRequest:request withTask:task];
    }else if(request.methodType ==RequestMethod_Post){
        NSURLSessionDataTask *task = [_requestManager POST:[request.url absoluteString] parameters:request.parameters
                      progress:^(NSProgress *progress){
                          if (progressBlock) {
                              progressBlock(progress,request.tag);
                          }
                      } success:^(NSURLSessionTask *task, id responseObject) {
                          HTRequest *curRequest = [self getCurrentRequest:task];
                          [self onResponseWithFinishBlock:responseBlock withErrorBlock:errorBlock withResponseObject:responseObject withRequest:curRequest];
                          [self removeCurrentRequest:task];
                          
                      } failure:^(NSURLSessionTask *operation, NSError *error) {
                          HTRequest *curRequest = [self getCurrentRequest:task];
                          [self onErrorwithBlock:errorBlock withRequest:curRequest];
                          [self removeCurrentRequest:task];
                      }];
        [self addCurrentRequest:request withTask:task];
    }
}

- (void)startAsynchronousWithBatchRequest:(NSArray *)batchRequest{
    if (!batchRequest || [batchRequest count]==0) {
        return;
    }
    
    NSInteger count = [batchRequest count];
    _bacthRequestCount = count;
    
    for (int i = 0; i<count; i++) {
        if (![batchRequest[i] isKindOfClass:[HTRequest class]]) {
            _bacthRequestCount --;
            
            continue;
        }
        
        if (_bacthRequestCount <=0) {
            break;
        }
        
        HTRequest *request = batchRequest[i];
        [self startAsynchronous:request];
    }
    
}

- (void)startAsynchronousWithBatchRequest:(NSArray *)batchRequest
                               onProgress:(HITResponseProgress)progressBlock
                               onResponse:(HITResponseObject)responseBlock
                                  onError:(HITResponseError)errorBlock{
    if (!batchRequest || [batchRequest count]==0) {
        return;
    }
    
    NSInteger count = [batchRequest count];
    _bacthRequestCount = count;
    
    for (int i = 0; i<count; i++) {
        if (![batchRequest[i] isKindOfClass:[HTRequest class]]) {
            _bacthRequestCount --;
            continue;
        }
        
        if (_bacthRequestCount <=0) {
            break;
        }
        
        HTRequest *request = batchRequest[i];
        [self startAsynchronous:request onProgress:progressBlock
                     onResponse:responseBlock onError:errorBlock];
    }

}

- (void)startUploadData:(HTRequest *)request withDataType:(DataType)dataType{
    [_requestManager POST:[request.url absoluteString] parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if (dataType == DataType_Image) {
            [formData appendPartWithFileData:request.data name:@"userfile"
                                    fileName:@"userfile.png" mimeType:@"image/png"];
        }else if (dataType == DataType_Audio){
            [formData appendPartWithFileData:request.data name:@"userfile" fileName:@"userfile.amr" mimeType:@"audio/AMR"];
        }else if (dataType == DataType_Viedo){
            [formData appendPartWithFileData:request.data name:@"video1" fileName:@"video1.mov" mimeType:@"video/quicktime"];
        }
        
    }progress:^(NSProgress *progress){
        if ([self.delegate respondsToSelector:@selector(requestProgress:withTag:)]){
             [self.delegate requestProgress:progress withTag:request.tag];
        }
    }success:^(NSURLSessionTask *task, id responseObject){
        [self onResponseWithFinishBlock:nil withErrorBlock:nil
                     withResponseObject:responseObject withRequest:request];
    }failure:^(NSURLSessionTask *operation, NSError *error){
        [self onErrorwithBlock:nil withRequest:request];
    }];
}

- (void)startUploadData:(HTRequest *)request withDataType:(DataType)dataType
             onProgress:(HITResponseProgress)progressBlock
             onResponse:(HITResponseObject)responseBlock
                onError:(HITResponseError)errorBlock{
    [_requestManager POST:[request.url absoluteString] parameters:request.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        if (dataType == DataType_Image) {
            [formData appendPartWithFileData:request.data name:@"userfile"
                                    fileName:@"userfile.png" mimeType:@"image/png"];
        }else if (dataType == DataType_Audio){
            [formData appendPartWithFileData:request.data name:@"userfile" fileName:@"userfile.amr" mimeType:@"audio/AMR"];
        }else if (dataType == DataType_Viedo){
            [formData appendPartWithFileData:request.data name:@"video1" fileName:@"video1.mov" mimeType:@"video/quicktime"];
        }
        
    }progress:^(NSProgress *progress){
        if (progressBlock){
            progressBlock(progress,request.tag);
        }
    }success:^(NSURLSessionTask *task, id responseObject){
        [self onResponseWithFinishBlock:responseBlock withErrorBlock:errorBlock
                     withResponseObject:responseObject withRequest:request];
    }failure:^(NSURLSessionTask *operation, NSError *error){
        [self onErrorwithBlock:errorBlock withRequest:request];
    }];
}

- (void)cancel{
    [_requestManager.operationQueue cancelAllOperations];
}

- (id)getCacheData:(HTRequest *)request{
    if (self.defaultUseCache) {
        return [[HTDataCache sharedManager]getCacheDataWithUrl:request.fullPath];
    }
    
    return nil;
}

#pragma mark - private method

- (void)onResponseWithFinishBlock:(HITResponseObject)responseBlock
               withErrorBlock:(HITResponseError)errorBlock
               withResponseObject:(id)responseObject
                      withRequest:(HTRequest *)request{
    
    HTNetWorkError *netWorkError = nil;
    id data = [self getJsonStr:responseObject withError:&netWorkError];
    
    if (netWorkError) {
        _bacthRequestCount = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            HTNetWorkError *netWorkError =[HTNetWorkError alloc];
            netWorkError.errorCode = -1;
            netWorkError.errorDescription = @"网络访问错误";
            if (errorBlock) {
                errorBlock(netWorkError);
            }else if ([self.delegate respondsToSelector:@selector(requestFailed:)]){
                [self.delegate requestFailed:netWorkError];
            }
            
            
        });
    }else {
        if (self.defaultUseCache) {
            [[HTDataCache sharedManager] cacheDataWithUrl:request.fullPath withData:data];
        }
        
        if(!_batchResponse){
            _batchResponse = [HTResponse shareResponseWithObject:data];
        }
        
        if (data) {
            [_batchResponse setObject:data withKey:request.tag];
        }
        
        _bacthRequestCount --;
        if (_bacthRequestCount >0) {
            return;
        }
        
        if(responseBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(_batchResponse);
            });
        }else if ([self.delegate respondsToSelector:@selector(requestFinished:)]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate requestFinished:_batchResponse];
            });
        }
        
    }

}

- (void)onErrorwithBlock:(HITResponseError)errorBlock
                      withRequest:(HTRequest *)request{
    _bacthRequestCount =0;
    
    HTNetWorkError *netWorkError =[HTNetWorkError alloc];
    netWorkError.errorCode = -1;
    netWorkError.errorDescription = @"网络访问错误";
    if (errorBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            errorBlock(netWorkError);
        });
    }else if ([self.delegate respondsToSelector:@selector(requestFailed:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate requestFailed:netWorkError];
        });
    }
}

- (id)getJsonStr:(id)responseObject withError:(HTNetWorkError **)dataError{
    
    NSError *error = nil;
    NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonStr = [[ NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    if (error) {
        *dataError =[[HTNetWorkError alloc]init];
        HTNetWorkError *networkError = *dataError;
        networkError.errorCode = -2;
        networkError.errorDescription = @"数据访问错误";
        return nil;

    }else if (self.defaultCheckMessage){
        return [self getJsonDataWithString:jsonStr withError:dataError];
    }else{
        return jsonStr;
    }
}

- (id)getJsonDataWithString:(NSString *)jsonStr withError:(HTNetWorkError **)dataError{
    NSError *error = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:jsonData
                             options:NSJSONReadingMutableLeaves error:&error];
    
    if (error || ![jsonDic objectForKey:@"msgCode"]
        || [[jsonDic objectForKey:@"msgCode"] isKindOfClass:[NSNull class]]) {
        *dataError =[[HTNetWorkError alloc]init];
        HTNetWorkError *networkError = *dataError;
        networkError.errorCode = -2;
        networkError.errorDescription = @"数据访问错误";
        return nil;
    }else if ([[jsonDic objectForKey:@"msgCode"] intValue] !=0){
        *dataError =[[HTNetWorkError alloc]init];
        HTNetWorkError *networkError = *dataError;
        networkError.errorCode = [[jsonDic objectForKey:@"msgCode"] intValue];
        networkError.errorDescription = [jsonDic objectForKey:@"msg"];
        return nil;
    }else{
        return [jsonDic objectForKey:@"data"];
    }
}

- (HTRequest *)getCurrentRequest:(NSURLSessionTask *)task{
    return [_batchRequest objectForKey:[NSString stringWithFormat: @"%lu", (unsigned long)task.taskIdentifier]];
}

- (void)addCurrentRequest:(HTRequest *)request withTask:(NSURLSessionTask *)task{
    [_batchRequest setObject:(id)request forKey:[NSString stringWithFormat: @"%lu", (unsigned long)task.taskIdentifier]];
}

- (void)removeCurrentRequest:(NSURLSessionTask *)task{
    [_batchRequest removeObjectForKey:[NSString stringWithFormat: @"%lu", (unsigned long)task.taskIdentifier]];
}


@end
