//
//  SFSetTypeModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSetTypeModel.h"

@implementation SFSetTypeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"_id" : @"id"
             };
}

/**
 * des:删除企业设置选项
 * author:SkyWork
 */
+(void)deleteCompanySetting:(NSString *)oid
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",companySettingModel,oid];
    [SFBaseModel DELETE:BASE_URL(URLString) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
/**
 * des:根据类型获取企业设置信息
 * author:SkyWork
 */
+(void)getCompanySetting:(NSString *)type
                 success:(void (^)(NSArray <SFSetTypeModel *> * list))success
                 failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",getCompanySettings,type];
    [SFBaseModel BGET:BASE_URL(URLString) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFSetTypeModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:修改企业设置选项
 * author:SkyWork
 */
+(void)updateCompanySetting:(NSDictionary *)parm
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(companySettingModel) parameters:parm success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:新增企业设置选项
 * author:SkyWork
 */
+(void)addCompanySetting:(NSDictionary *)parm
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(companySettingModel) parameters:parm success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

@end
