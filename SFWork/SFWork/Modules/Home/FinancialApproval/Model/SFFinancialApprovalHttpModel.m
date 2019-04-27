//
//  SFFinancialApprovalHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFinancialApprovalHttpModel.h"

@implementation SFFinancialApprovalHttpModel

/**
 * des://获取我的审批列表(分组数据)，组内列表数据最多5条
 * author:SkyWork
 */
+(void)myApproveBillGroups:(NSDictionary *)prame
                   success:(void (^)(NSArray * list))success
                   failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(myApproveBillGroup) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        
        NSArray * array1 = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"APPROVING"]];
        NSArray * array2 = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"APPROVED"]];
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:array1];
        [array addObject:array2];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des://获取我的发起列表(分组数据)，组内列表数据最多5条
 * author:SkyWork
 */
+(void)myLaunchBillfinaceGroups:(NSDictionary *)prame
                        success:(void (^)(NSArray * list))success
                        failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(myLaunchBillfinaceGroup) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        
        NSArray * array1 = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"APPROVING"]];
        NSArray * array2 = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"APPROVED"]];
        NSMutableArray * array = [NSMutableArray array];
        [array addObject:array1];
        [array addObject:array2];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:财务单据审批处理
 * author:SkyWork
 */
+(void)finacebillProcess:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(finacebillprocess) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:
 * author:SkyWork
 */
+(void)myApproveBillfinaceProcess:(NSDictionary *)prame
                        isApprove:(BOOL)isApprove
                          success:(void (^)(NSArray * list))success
                          failure:(void (^)(NSError *))failure {
    
    NSString * URLString = isApprove ? BASE_URL(myApproveBillfinace) : BASE_URL(myLaunchBillfinace);
    [SFBaseModel BPOST:URLString parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(16)
        NSArray * array = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:财务单据列表
 * author:SkyWork
 */
+(void)finaceBillListProcess:(NSDictionary *)prame
                     success:(void (^)(NSArray * list))success
                     failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(finacebillList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(16)
        NSArray * array = [NSArray modelArrayWithClass:[SFFinancialModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}



/**
 * des: 单据详情
 * author:SkyWork
 */
+(void)getFinancialApprovalDateil:(NSString *)financial_id
                          success:(void (^)(SFFinancialModel * model))success
                          failure:(void (^)(NSError *))failure {
    
    NSString * urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL(finacebillDateil),financial_id];
    [SFBaseModel BGET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFFinancialModel * mod = [SFFinancialModel modelWithJSON:model.result];
        
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:新增财务单据
 * author:SkyWork
 */
+(void)addfinacebillProcess:(NSDictionary *)prame
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(addfinacebill) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}


@end

@implementation SFFinancialModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"billProcessDTOList" : [BillProcessModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end

@implementation BillProcessModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
