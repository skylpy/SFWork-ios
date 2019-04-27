//
//  SFCustomerHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCustomerHttpModel.h"
#import "SFCustomerModel.h"

@implementation SFCustomerHttpModel

/**
 * des:新增客户
 * author:SkyWork
 */
+(void)addCompanyClient:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(clientAdd) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取部门客户/商家
 * author:SkyWork
 */
+(void)getDepCompanyClient:(NSDictionary *)prame
                   success:(void (^)(NSArray <SFClientModel *> *list))success
                   failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(getDepartmentClient) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFClientModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取个人客户/商家
 * author:SkyWork
 */
+(void)getMyCompanyClient:(NSDictionary *)prame
                  success:(void (^)(NSArray <SFClientModel *> *list))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(getMyClient) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFClientModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取下属私有客户/商家
 * author:SkyWork
 */
+(void)getPrivateClient:(NSDictionary *)prame
                success:(void (^)(NSArray <SFClientModel *> *list))success
                failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(getDirectly) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        NSArray * array = [NSArray modelArrayWithClass:[SFClientModel class] json:model.result];
        !success?:success(array);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:通过id查询客户
 * author:SkyWork
 */
+(void)getClients:(NSString *)cid
          success:(void (^)(SFClientModel * model))success
          failure:(void (^)(NSError * error))failure{
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(getClient),cid];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:cid forKey:@"id"];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        SFClientModel * cmodel = [SFClientModel modelWithJSON:model.result];
        !success?:success(cmodel);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:删除客户信息
 * author:SkyWork
 */
+(void)deleteClient:(NSString *)URLString
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure{
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_URL(getClient),URLString];
    [SFBaseModel DELETE:URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改客户信息
 * author:SkyWork
 */
+(void)updateClients:(NSDictionary *)pram
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(updateClient) parameters:pram success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:搜索商家或客户
 * author:SkyWork
 */
+(void)searchClients:(NSDictionary *)prame
             success:(void (^)(NSArray <SFClientModel *> *list))success
             failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(searchClient) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        NSArray * array = [NSArray modelArrayWithClass:[SFClientModel class] json:model.result];
        !success?:success(array);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}


@end
