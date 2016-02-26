//
//  ViewController.m
//  HTNetWorkDemo
//
//  Created by Horae.Tech on 16/1/29.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<HTRequestDelegate>{
    HTNetWorkClient *_client;
    HTRequestConfig *_config;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initRequestConfig];
    _client=[[HTNetWorkClient alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initRequestConfig{
    _config=[[HTRequestConfig alloc] init];
    // dummy
    _config.baseUrl=@"http://11.11.11.11:8090/api/";
}

#pragma mark- Use HTRequestDelegate Sample
- (void)startAsynchronous{
    _client.delegate=self;
    HTRequest *request =[HTRequest sharedRequestWithMethodType:RequestMethod_Get withPath:@"Article/QueryArticleList" withParam:nil withConfig:_config];
    [_client startAsynchronous:request];
}

- (void)requestStart{
    NSLog(@"start request");
}

- (void)requestProgress:(NSProgress *)progress withTag:(NSString *)tag{
    NSLog(@"progress");
}

- (void)requestFinished:(id)response{
    NSLog(@"Finished");
}

- (void)requestFailed:(HTNetWorkError *)request{
    NSLog(@"Failed");
}

#pragma mark- Use Block Sample
- (void)startAsynchronousWithBlock{

    HTRequest *request =[HTRequest sharedRequestWithMethodType:RequestMethod_Get withPath:@"Article/QueryArticleList" withParam:nil withConfig:_config];
    NSLog(@"start request");
    
    [_client startAsynchronous:request onProgress:^(NSProgress *progress, NSString *tag){
       NSLog(@"progress");
        
    }onResponse:^(HTResponse *response){
        NSLog(@"Finished");
        
    }onError:^(HTNetWorkError* responseError){
        NSLog(@"Failed");
    }];
}

#pragma mark - AsynchronousWithBatchRequest
- (void)start{
    HTRequest *request =[HTRequest sharedRequestWithMethodType:RequestMethod_Get withPath:@"Article/QueryArticleList" withParam:nil withConfig:_config];
    
    request.tag=@"QueryArticleList";
    
    HTRequest *request2 =[HTRequest sharedRequestWithMethodType:RequestMethod_Get withPath:@"Article/QueryArticleOther" withParam:nil withConfig:_config];
    request2.tag=@"QueryArticleOther";
    
    NSArray *requestArray=@[request,request2];
    
    [_client startAsynchronousWithBatchRequest:requestArray onProgress:^(NSProgress *progress, NSString *tag){
        NSLog(@"progress");
        
    }onResponse:^(HTResponse *response){
        id data1 = [response getObjectByKey:@"QueryArticleList"];
        id data2 = [response getObjectByKey:@"QueryArticleOther"];
        NSLog(@"Finished");
        
    }onError:^(HTNetWorkError* responseError){
        NSLog(@"Failed");
    }];
}

@end
