//
//  HttpManager.h
//  AFNetworking
//
//  Created by Wilbur on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"

#define ShareHttpManager [HttpManager shareHttpManager]
#define kReachabilityStatusChange @"kReachabilityChangedNotification"
#define ShareNoTokenManager [NoTokenManager shareHttpManager]
#define ShareOSSTokenManager [AliOSSManager shareHttpManager]
typedef void (^SuccessResponse)(NSURLSessionDataTask *task, id responseObject);

typedef void (^CacheSuccessResponse)(NSURLSessionDataTask *task, BOOL fromCache, id responseObject);

typedef void (^FailureResponse)(NSURLSessionDataTask *task, NSError *error);
typedef void (^RequestProgress)(NSProgress *progress);
typedef void (^DownloadHandler)(NSURLResponse *response, NSURL *filePath, NSError *error);

@interface HttpManager : AFHTTPSessionManager

+ (instancetype)shareHttpManager;

#pragma mark - Get请求
//没有缓存Get请求
+ (void)GET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)GET:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//有缓存的请求
+ (void)GETWithCache:(NSString *)urlString parameters:(id)params success:(CacheSuccessResponse)success failure:(FailureResponse)failure;

+ (void)GETWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(CacheSuccessResponse)success failure:(FailureResponse)failure;


#pragma mark - Post请求
//没有缓存的Post请求
+ (void)POST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

+ (void)POST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//没有缓存的Post请求
+ (void)POSTWithCache:(NSString *)urlString parameters:(id)params success:(CacheSuccessResponse)success failure:(FailureResponse)failure;

+ (void)POSTWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(CacheSuccessResponse)success failure:(FailureResponse)failure;



//没有缓存的PUT请求
+ (void)PUT:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

//没有缓存的DELETE请求
+ (void)DELETE:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;

#pragma mark - 其他请求
// 文件下载
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler;
// 视频下载
+ (NSURLSessionDownloadTask *)downloadViode:(NSURL *)url downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler;
//图片上传
+ (NSURLSessionDataTask *)uploadImage:(NSString *)urlString parameters:(id)params images:(NSArray *)images keys:(NSArray *)keys uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//视频上传
+ (NSURLSessionDataTask *)uploadVideo:(NSString *)urlString parameters:(id)params video:(NSData *)video key:(NSString *)key uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure;

//取消请求
+ (void)httpCancelAllRequest;

#pragma mark - 网络监听

///需要添加监听通知 kReachabilityChangedNotification
- (void)startNotifierReachability;

- (void)stopNotifierReachability;

@end

typedef void (^FaiResponse)(BaseModel * model);

@interface NoTokenManager : AFHTTPSessionManager
//登录
+ (void)LoginPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FaiResponse)failure;
//登录注册
+ (void)LRPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure;
//获取
+ (void)LRGET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure ;

@end


