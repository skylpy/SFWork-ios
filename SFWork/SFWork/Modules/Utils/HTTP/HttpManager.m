//
//  HttpManager.h
//  AFNetworking
//
//  Created by Wilbur on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "HttpManager.h"
#import "YYCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+LSCompression.h"

#define CacheFolder @"HttpCache"

static HttpManager *manager;

@interface HttpManager ()

//默认开启网络监听
@property (nonatomic, strong) Reachability *reach;

@property (nonatomic, strong) YYCache *httpCache;

@end

@implementation HttpManager

//定义单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        manager.reach = reach;
        manager.httpCache = [[YYCache alloc] initWithName:CacheFolder];
    });
    return manager;
}

+ (instancetype)shareHttpManager {
    if (!manager) {
        manager = [HttpManager new];
        [self initAttributeWith:manager];
        
    }
    return manager;
}

+ (void)initAttributeWith:(HttpManager *)manager {

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;

    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应的类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",  @"text/json", @"text/javascript", @"text/html", nil];
    
    //设置请求的类型
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[SFInstance shareInstance].token forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"phoneSystem"];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:LoginNotificationSuccess object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [manager.requestSerializer setValue:[SFInstance shareInstance].token forHTTPHeaderField:@"token"];
    }];
}

#pragma mark - Get请求

+ (void)GET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {

    [self GET:urlString parameters:params requestProgress:nil success:success failure:failure];

}

+ (void)GET:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {

    [ShareHttpManager GET:urlString parameters:params progress:^(NSProgress *downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

}

+ (void)GETWithCache:(NSString *)urlString parameters:(id)params success:(CacheSuccessResponse)success failure:(FailureResponse)failure {

    [self GETWithCache:urlString parameters:params requestProgress:nil success:success failure:failure];

}

+ (void)GETWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(CacheSuccessResponse)success failure:(FailureResponse)failure {

    //缓存的key：url+"#参数值"的MD5加密的字符串
    NSString *keyOfCache = [self keyWithUrl:urlString params:params];

    id data = [ShareHttpManager.httpCache objectForKey:keyOfCache];

    //有缓存数据，先回调缓存数据
    if (data) {
        if (success) {
            success(nil, YES, data);
        }
    }

    [ShareHttpManager GET:urlString parameters:params progress:^(NSProgress *downloadProgress) {

        if (progress) {
            progress(downloadProgress);
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject===%@",responseObject);
        if (success) {
            success(task, NO, responseObject);
        }

        [ShareHttpManager.httpCache setObject:responseObject forKey:keyOfCache];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        if (failure) {
            failure(task, error);
        }

    }];

}

#pragma mark - Post请求


+ (void)POST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self POST:urlString parameters:params requestProgress:nil success:success failure:failure];

}

+ (void)POST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [ShareHttpManager POST:urlString parameters:params progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(task, error);
        }
    }];
}

+ (void)POSTWithCache:(NSString *)urlString parameters:(id)params success:(CacheSuccessResponse)success failure:(FailureResponse)failure {

    [self POSTWithCache:urlString parameters:params requestProgress:nil success:success failure:failure];

}

+ (void)POSTWithCache:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(CacheSuccessResponse)success failure:(FailureResponse)failure {

    NSString *keyOfCache = [self keyWithUrl:urlString params:params];

    id data = [ShareHttpManager.httpCache objectForKey:keyOfCache];

    //有缓存数据,从缓存中获取数据
    if (data) {
        if (success) {
            success(nil, YES, data);
        }
    }

    [ShareHttpManager POST:urlString parameters:params progress:^(NSProgress *uploadProgress) {

        if (progress) {
            progress(uploadProgress);
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {

        if (success) {
            success(task, NO, responseObject);
        }
        NSLog(@"请求成功===%@",responseObject);
        [ShareHttpManager.httpCache setObject:responseObject forKey:keyOfCache];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败===%@",task.response);
        if (failure) {
            failure(task, error);
        }

    }];

}

+ (void)PUT:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure{
    
    [ShareHttpManager PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}

//没有缓存的DELETE请求
+ (void)DELETE:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure{
    
    [ShareHttpManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
        }
    }];
}


#pragma mark - Download
+ (NSURLSessionDownloadTask *)download:(NSString *)urlString downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler {

    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSURLSessionDownloadTask *downloadTask;

    downloadTask = [ShareHttpManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress *downloadProgress) {

        if (progress) {
            progress(downloadProgress);
        }

    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];

        return [NSURL fileURLWithPath:filePath];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        if (handler) {
            handler(response, filePath, error);
        }

    }];

    [downloadTask resume];

    return downloadTask;
}

+ (NSURLSessionDownloadTask *)downloadViode:(NSURL *)url downloadProgress:(RequestProgress)progress completeHandler:(DownloadHandler)handler {
    
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask;
    
    downloadTask = [ShareHttpManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress *downloadProgress) {
        
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
//        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        NSString *filePath = [kCaptureFolder stringByAppendingPathComponent:response.suggestedFilename];
        
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"%@",response);
        if (handler) {
            handler(response, filePath, error);
        }
        
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}

+ (NSURLSessionDataTask *)uploadImage:(NSString *)urlString parameters:(id)params images:(NSArray *)images keys:(NSArray *)keys uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {

    NSURLSessionDataTask *uploadTask;

    uploadTask = [ShareHttpManager POST:urlString parameters:params constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {

        NSAssert(images.count == keys.count, @"图片的数量和keys的数量不一致");

        for (int i = 0; i < images.count; i++) {
            UIImage *image = images[i];
            NSString *key = keys[i];
            
            NSData * imageData = [UIImage compressionImage:image];
        
            NSString *fileName = [NSString stringWithFormat:@"image%d.jpeg", i];

            [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress *uploadProgress) {

        if (progress) {
            progress(uploadProgress);
        }

    } success:^(NSURLSessionDataTask *task, id responseObject) {

        if (success) {
            success(task, responseObject);
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];

    return uploadTask;
}

+ (NSURLSessionDataTask *)uploadVideo:(NSString *)urlString parameters:(id)params video:(NSData *)video key:(NSString *)key uploadProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    NSURLSessionDataTask *uploadTask;
    
    uploadTask = [ShareHttpManager POST:urlString parameters:params constructingBodyWithBlock:^(id < AFMultipartFormData > formData) {
        
        if (video)
        {
            [formData appendPartWithFileData:video name:key fileName:@"我是帅哥.mp4" mimeType:@"video/mp4"];
        }
        
    } progress:^(NSProgress *uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
    return uploadTask;

}

+ (void)httpCancelAllRequest {
    [ShareHttpManager.operationQueue cancelAllOperations];
}

#pragma mark - 网络监听
- (void)startNotifierReachability {
    [self.reach startNotifier];
}

- (void)stopNotifierReachability {
    [self.reach stopNotifier];
}

+ (NSString *)keyWithUrl:(NSString *)urlString params:(NSDictionary *)params {
    if (params == nil) return nil;

    NSMutableArray *paramNames = [NSMutableArray arrayWithArray:[params allKeys]];

    // 即是key是我要传输的参数名按ASCII顺序追加起来（再加上固定名称）md5出来的
    NSArray *newParamNames = [paramNames sortedArrayUsingComparator:^NSComparisonResult (id obj1, id obj2) {

        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;

        return [string1 compare:string2 options:NSNumericSearch];
    }];

    NSMutableString *key = [[NSMutableString alloc] initWithString:urlString];

    for (NSString *paramName in newParamNames) {
        id paramValue = params[paramName];
        NSString *paramValueString = [NSString stringWithFormat:@"#%@", paramValue];
        [key appendString:paramValueString];
    }

    return [self MD5:key];
}

/** 无网络或连接不上服务器时显示 */
//+ (void)netStatusChangedWithNoNetwork:(BOOL)noNetWork{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIApplication sharedApplication].keyWindow.rootViewController = [[NetworkViewController alloc] initWithNoNetwork:noNetWork];
//    });
//
//}

+ (NSString *)MD5:(NSString *)string {
    // Create pointer to the string as UTF8
    const char *ptr = [string UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", md5Buffer[i]];

    return output;
}

@end

static NoTokenManager *nomanager;
@interface NoTokenManager()
//默认开启网络监听
@property (nonatomic, strong) Reachability *reach;

@end

@implementation NoTokenManager

//定义单例
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nomanager = [super allocWithZone:zone];
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        nomanager.reach = reach;
        
    });
    return nomanager;
}
+ (instancetype)shareHttpManager {
    if (!nomanager) {
        nomanager = [NoTokenManager new];
        [self initAttributeWith:nomanager];
        
    }
    return nomanager;
}

+ (void)initAttributeWith:(NoTokenManager *)manager {
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    
    manager.responseSerializer = responseSerializer;
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置响应的类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",  @"text/json", @"text/javascript", @"text/html", nil];
    
    //设置请求的类型
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"phoneSystem"];
}

+ (void)LRGET:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self LRGET:urlString parameters:params requestProgress:nil success:success failure:failure];
    
}

+ (void)LRGET:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [ShareNoTokenManager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                NSDictionary *errorDataDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                SFBaseModel *model = [SFBaseModel modelWithJSON:errorDataDict];
                NSError *error = [self errorFormatBaseModel:model];
                //            !failure?:failure(task,error);
                failure(task, error);
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInView:@"网络故障，请查看您的网络"];
            }
            
        }
    }];
    
}

+ (void)LRPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [self LRPOST:urlString parameters:params requestProgress:nil success:success failure:failure];
    
}

+ (void)LRPOST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FailureResponse)failure {
    
    [ShareNoTokenManager POST:urlString parameters:params progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            
            if (errorData) {
                NSDictionary *errorDataDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                
                BaseModel *model = [BaseModel modelWithJSON:errorDataDict];
                
                NSError *error = [self errorFormatBaseModel:model];
                
                failure(task, error);
            }else{
                
                
                [MBProgressHUD showTipMessageInView:@"网络故障，请查看您的网络"];
            }
            
        }
    }];
}

+ (void)LoginPOST:(NSString *)urlString parameters:(id)params success:(SuccessResponse)success failure:(FaiResponse)failure {
    
    [self LoginPOST:urlString parameters:params requestProgress:nil success:success failure:failure];
    
}

+ (void)LoginPOST:(NSString *)urlString parameters:(id)params requestProgress:(RequestProgress)progress success:(SuccessResponse)success failure:(FaiResponse)failure {
    
    [ShareNoTokenManager POST:urlString parameters:params progress:^(NSProgress *uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            if (errorData) {
                NSDictionary *errorDataDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
                
                BaseModel *model = [BaseModel modelWithJSON:errorDataDict];
                
                failure(model);
            }else{
                
                [MBProgressHUD showTipMessageInView:@"网络故障，请查看您的网络"];
            }
            
        }
    }];
}

//格式化错误信息
+ (NSError *)errorFormatBaseModel:(BaseModel *)baseModel {
    NSString *msg = baseModel.errorMsg;
    
    NSInteger code = baseModel.status;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (msg) {
        [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
    } else {
        [userInfo setObject:@"服务异常" forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    //设置statusCode
    
    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:code userInfo:userInfo];
    
    return formattedError;
}
@end


