//
//  SFPowerHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerHttpModel.h"

@implementation SFPowerHttpModel

/**
 * des:获取权限列表
 * author:SkyWork
 */
+(void)getMyPowerListsType:(NSString *)type
                   success:(void (^)(NSArray <SFPowerListModel *>*list))success
                   failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(employeePermissionList),type];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFPowerListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取根据类型获取默认权限设置
 * author:SkyWork
 */
+(void)getDefaultPermission:(NSString *)type
                    success:(void (^)(NSArray <PermissionsModel *>*list))success
                    failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(getDefaultPermissions),type];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[PermissionsModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取授权信息详情
 * author:SkyWork
 */
+(void)getPermissionListsPid:(NSString *)pid
                     success:(void (^)(EmpPermissionModel * model))success
                     failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(employeePermission),pid];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        EmpPermissionModel * pmodel = [EmpPermissionModel modelWithJSON:model.result];
        !success?:success(pmodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:对用户进行授权
 * author:SkyWork
 */
+(void)addPermissioneUser:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(permissionAuthorization) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:删除授权
 * author:SkyWork
 */
+(void)deletePermissioneUser:(NSString *)pid
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(employeePermission),pid];
    [SFBaseModel DELETE:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation SFPowerListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation EmpPermissionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"permissions" : [PermissionsModel class]};
}

@end
