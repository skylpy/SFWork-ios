//
//  SFBaseModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseModel.h"
#import "HttpManager.h"
#import "UIView+SFHUD.h"

@implementation SFBaseModel


+ (void)BGET:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *, SFBaseModel *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
   
    [HttpManager GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功 === %@ == %@", task.response, responseObject);
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:NO success:^(NSURLSessionDataTask *task, BOOL fromCache, SFBaseModel *model) {
        
            !success?:success(task,model);
        } failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        [self failureReduce:task error:error complete:failure];
    }];
}

+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *, BOOL, SFBaseModel *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [HttpManager GETWithCache:urlString parameters:params success:^(NSURLSessionDataTask *task, BOOL fromCache, id responseObject) {
        
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:fromCache success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureReduce:task error:error complete:failure];
    }];
}

+ (void)BPOST:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *, SFBaseModel *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    NSLog(@"===========请求数组%@",params);
    [HttpManager POST:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"请求成功 === %@ == %@", task.response, responseObject);
        
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:NO success:^(NSURLSessionDataTask *task, BOOL fromCache, SFBaseModel *model) {
            !success?:success(task,model);
        } failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败====%@", task.response);
        [self failureReduce:task error:error complete:failure];
    }];
}

+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *, BOOL, SFBaseModel *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [HttpManager POSTWithCache:urlString parameters:params success:^(NSURLSessionDataTask *task, BOOL fromCache, id responseObject) {
        
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:fromCache success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureReduce:task error:error complete:failure];
    }];
    
}

+ (void)BPUT:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    [HttpManager PUT:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:NO success:^(NSURLSessionDataTask *task, BOOL fromCache, SFBaseModel *model) {
            !success?:success(task,model);
        } failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureReduce:task error:error complete:failure];
    }];
}

+ (void)DELETE:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure{
    
    [HttpManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self reduceResponseObject:responseObject sessionTask:task isFromCache:NO success:^(NSURLSessionDataTask *task, BOOL fromCache, SFBaseModel *model) {
            !success?:success(task,model);
        } failure:failure];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self failureReduce:task error:error complete:failure];
    }];
}

+ (void)failureReduce:(NSURLSessionDataTask *)task error:(NSError *)error complete:(void (^)(NSURLSessionDataTask *, NSError *error))failure {
    
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    NSData *errorData = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    if (responses.statusCode == 401) {
        [LSKeyWindow showAlertWithTitle:@"提示" message:@"账号在其他手机登录,请退出或重新登录" doneAction:^{
            [[SFInstance shareInstance] logout];
        }];
        return;
    }else{
        if (errorData) {
            NSDictionary *errorDataDict = [NSJSONSerialization JSONObjectWithData:errorData options:NSJSONReadingMutableLeaves error:nil];
            SFBaseModel *model = [SFBaseModel modelWithJSON:errorDataDict];
            if (model.status == 401) {
                
                [LSKeyWindow showAlertWithTitle:@"提示" message:@"账号在其他手机登录,请退出或重新登录" doneAction:^{
                    [[SFInstance shareInstance] logout];
                }];
                
            }else{
                NSError *error = [self errorFormatBaseModel:model];
                !failure?:failure(task,error);
            }
            
        }else{
            [MBProgressHUD showTipMessageInView:@"网络故障，请查看您的网络"];
        }
        if (error.code == -1009) {
            [UIAlertController alertTitle:@"温馨提示" mesasge:@"网络故障，请检查您的网络" preferredStyle:UIAlertControllerStyleAlert confirmHandler:^(UIAlertAction *alertAction) {
                
            } cancleHandler:^(UIAlertAction * alert) {
                
            } viewController:[UIViewController getCurrentVC]];
            
        };
    }
}

//返回数据的处理
+ (void)reduceResponseObject:(id)responseObject sessionTask:(NSURLSessionDataTask *)task isFromCache:(BOOL)fromCache success:(void (^)(NSURLSessionDataTask *task,BOOL fromCache, SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
    
    NSDictionary * dict = @{
                            @"status":@(responses.statusCode),
                            @"errorMsg":@"请求成功",
                            @"result":responseObject == nil?@{}:responseObject
                            };
    SFBaseModel *model = [SFBaseModel modelWithJSON:dict];
    if (responses.statusCode == 401) {
        [LSKeyWindow showAlertWithTitle:@"提示" message:@"账号使用异常,请重新登录" doneAction:^{
            [[SFInstance shareInstance] logout];
        }];
        
        return;
    }
    
    if (responses.statusCode == 200) {
        if (success) {
            success(task, fromCache, model);
        }
    }
    else {
        NSError *error = [self errorFormatBaseModel:model];
        !failure?:failure(task,error);
    }
}

//格式化错误信息
+ (NSError *)errorFormatBaseModel:(SFBaseModel *)baseModel {
    NSString *msg = baseModel.errorMsg;
    
    NSInteger code = baseModel.status;
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (msg) {
        [userInfo setObject:msg forKey:NSLocalizedFailureReasonErrorKey];
    } else {
        [userInfo setObject:@"服务异常" forKey:NSLocalizedFailureReasonErrorKey];
    }
    
    //设置statusCode
    if ([baseModel.result isKindOfClass:[NSDictionary class]]) {
        NSString *statusCode = baseModel.result[@"statusCode"];
        if (statusCode) {
            code = [statusCode integerValue];
        }
    }
    
    NSError *formattedError = [[NSError alloc] initWithDomain:NSOSStatusErrorDomain code:code userInfo:userInfo];
    
    return formattedError;
}

+ (void)uploadImages:(NSString *)urlString
          parameters:(id)params
              images:(NSArray *)images
                keys:(NSArray *)keys
             success:(void (^)(NSURLSessionDataTask *, SFBaseModel *))success
             failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [HttpManager uploadImage:urlString
                  parameters:params
                      images:images
                        keys:keys
              uploadProgress:nil
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         SFBaseModel *model = [SFBaseModel modelWithJSON:responseObject];
                         NSLog(@"请求成功 === %@", responseObject);
                         if (model.status == 200) {
                             if (success) {
                                 success(task, model);
                             }
                         } else {
                             NSError *error = [self errorFormatBaseModel:model];
                             !failure ?: failure(task, error);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         !failure ?: failure(task, error);
                     }];
}

+ (NSString *)errorMessageFromError:(NSError *)error {
    
    if (!error) return nil;
    
    if (error.code == -1009) {
        return @"网络异常";
    }
    
    id userInfo = [error userInfo];
    NSString *errorMsg;
    
    if ([userInfo objectForKey:NSLocalizedFailureReasonErrorKey]) {
        errorMsg = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    } else if ([userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]) {
        errorMsg = [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
    } else {
        errorMsg = [error localizedDescription];
    }
    
    return errorMsg;
}

+ (void)BPOSTGroup:(NSString *)urlString
        parameters:(id)params
           success:(void (^)(NSURLSessionDataTask *task, SFBaseModel *model))success
           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    [HttpManager POST:urlString
           parameters:params
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  
                  SFBaseModel *model = [SFBaseModel modelWithJSON:responseObject];
                  NSLog(@"请求成功==== %@ == %@", task.response, responseObject);
                  if (!model) { //没有返回值的情况
                      if (success) {
                          success(task, model);
                      }
                  } else {
                      if (model.status == 200) {
                          if (success) {
                              success(task, model);
                          }
                      } else {
                          NSError *error = [self errorFormatBaseModel:model];
                          !failure ?: failure(task, error);
                      }
                  }
                  
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"请求失败====%@", task.response);
                  !failure ?: failure(task, error);
              }];
}

@end

@implementation BaseModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"arguments" : [BaseErrorModel class]
             };
}

@end

@implementation BaseErrorModel


@end
