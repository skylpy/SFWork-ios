//
//  SFFilesMgrModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFilesMgrModel.h"
#import "HttpManager.h"
#import "SFAliOSSManager.h"
static OSSClient * client;
@implementation SFFilesMgrModel

/**
 * des:重命名文件夹或文件
 * author:SkyWork
 */
+(void)renameOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(renameFiles) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/**
 * des:移动文件夹或文件
 * author:SkyWork
 */
+(void)removeOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(deleteFiles) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/**
 * des:删除文件夹或文件
 * author:SkyWork
 */
+(void)deleteOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(deleteFiles) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:添加文件夹
 * author:SkyWork
 */
+(void)addOfficeFolder:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(addOfficeFile) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取文件列表
 * author:SkyWork
 */
+(void)getOfficeFolder:(NSDictionary *)prame
               success:(void (^)(NSArray <SFFilesModel *> *lsit))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(getOfficeFileList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        NSArray * array = [NSArray modelArrayWithClass:[SFFilesModel class] json:model.result];
        !success?:success(array);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/** 设置OSSClient */
+ (void)setupOSSClient{
    
    [HttpManager GET:BASE_URL(getOssRoleToken) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *AccessKeyId = responseObject[@"accessKeyId"];
        NSString *AccessKeySecret = responseObject[@"accessKeySecret"];
        NSString *SecurityToken = responseObject[@"securityToken"];
        NSString *endpoint = responseObject[@"endpoint"];
        // 移动端建议使用STS方式初始化OSSClient。更多鉴权模式请参考后面的访问控制章节。
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:AccessKeyId secretKeyId:AccessKeySecret securityToken:SecurityToken];
        OSSClientConfiguration * conf = [OSSClientConfiguration new];
        // 网络请求遇到异常失败后的重试次数
        conf.maxRetryCount = 3;
        // 网络请求的超时时间
        conf.timeoutIntervalForRequest = 30;
        // 允许资源传输的最长时间
        conf.timeoutIntervalForResource = 24 * 60 * 60;
        client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
        [SFAliOSSManager sharedInstance].client = client;
        
        [SFInstance shareInstance].bucketName = responseObject[@"bucketName"];
        [SFInstance shareInstance].endpoint = responseObject[@"endpoint"];
        [SFInstance shareInstance].expiration = responseObject[@"expiration"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

@end

@implementation SFFilesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
