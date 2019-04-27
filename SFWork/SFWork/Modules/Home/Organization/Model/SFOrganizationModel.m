//
//  SFOrganizationModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFOrganizationModel.h"

@implementation SFOrganizationModel

/**
 * des:修改员工角色
 * author:SkyWork
 */
+(void)updateEmployeeRole:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(changeRole) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}
/**
 * des:新增员工
 * author:SkyWork
 */
+(void)addCompanyEmployee:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(addEmployee) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:修改员工
 * author:SkyWork
 */
+(void)updateCompanyEmployee:(NSDictionary *)prame
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(updateEmployee) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:修改部门
 * author:SkyWork
 */
+(void)updateCompanyDep:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(updateDepartment) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:新增部门
 * author:SkyWork
 */
+(void)addCompanyDep:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(addDepartment) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取组织架构
 * author:SkyWork
 */
+(void)getOrganizationList:(NSDictionary *)parm
                   success:(void (^)(SFOrgListModel * model))success
                   failure:(void (^)(NSError *))failure{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFBaseModel BGET:BASE_URL(getOrganization) parameters:parm success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        SFOrgListModel * org = [SFOrgListModel modelWithJSON:model.result];
        !success?:success(org);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des:获取组织架构(全部)
 * author:SkyWork
 */
+(void)getOrganizationAllList:(NSDictionary *)parm
                      success:(void (^)(SFOrgListModel * model))success
                      failure:(void (^)(NSError *))failure{
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    [SFBaseModel BGET:BASE_URL(getOrganizationTree) parameters:parm success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        SFOrgListModel * org = [SFOrgListModel modelWithJSON:model.result];
        !success?:success(org);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des:直属上司接口
 * author:SkyWork
 */
+(void)getDirectlyAdminsSuccess:(void (^)(NSArray <SFEmployeesModel *>*list))success
                        failure:(void (^)(NSError *))failure{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(getDirectlyAdmin),[SFInstance shareInstance].userInfo._id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        NSArray * array = [NSArray modelArrayWithClass:[SFEmployeesModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des:直属下属接口
 * author:SkyWork
 */
+(void)getDirectlyEmployeesSuccess:(void (^)(NSArray <SFEmployeesModel *>*list))success
                           failure:(void (^)(NSError *))failure{
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(getDirectlyEmployee),[SFInstance shareInstance].userInfo._id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        NSArray * array = [NSArray modelArrayWithClass:[SFEmployeesModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des:获取子部门
 * author:SkyWork
 */
+(void)orgGetChildrenList:(NSString *)oid
                  success:(void (^)(NSArray <SFOrgListModel * >*list))success
                  failure:(void (^)(NSError *))failure{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(orgGetChildren),oid];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        NSArray * array = [NSArray modelArrayWithClass:[SFOrgListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
* des:获取所有员工
* author:SkyWork
*/

+(void)getAllEmployeeListSuccess:(void (^)(NSArray <SFEmployeesModel * >*list))success
                         failure:(void (^)(NSError *))failure{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
   
    [SFBaseModel BGET:BASE_URL(getAllEmployee) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        NSArray * array = [NSArray modelArrayWithClass:[SFEmployeesModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des: 获取所有管理者
 * author:SkyWork
 */

+(void)getAllManagerListSuccess:(void (^)(NSArray <SFEmployeesModel * >*list))success
                        failure:(void (^)(NSError *))failure{
    
    [MBProgressHUD showActivityMessageInView:@"加载中..."];
    
    [SFBaseModel BGET:BASE_URL(getAllManager) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        [MBProgressHUD hideHUD];
        NSArray * array = [NSArray modelArrayWithClass:[SFEmployeesModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        !failure?:failure(error);
    }];
}

/**
 * des: 删除部门
 * author:SkyWork
 */
+(void)deleteDepartments:(NSString *)dep_id
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    NSString * urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL(deleteDepartment),dep_id];
    
    [SFBaseModel DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:批量删除员工
 * author:SkyWork
 */
+(void)deleteOrgEmployee:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(deleteEmployee) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:批量y移动员工
 * author:SkyWork
 */
+(void)moveOrgEmployee:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(moveEmployee) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

@end

@implementation SFOrgListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"children" : [SFOrgListModel class],
             @"employees" : [SFEmployeesModel class],
             @"admins":[SFEmployeesModel class]
             };
}

@end

@implementation SFEmployeesModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end
