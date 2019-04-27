
//
//  SFExpenseHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpenseHttpModel.h"

@implementation SFExpenseHttpModel

/**
 * des:新增费用报销
 * author:SkyWork
 */
+(void)postAddExpense:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(officeReimbursement) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 审批
 * author:SkyWork
 */
+(void)postDoApprove:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(doApproveDoApprove) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取待我审批/我审批的
 * author:SkyWork
 */
+(void)postgetApprove:(NSDictionary *)prame
              success:(void (^)(NSArray <ExpenseListModel *>*list))success
              failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BPOST:BASE_URL(getApproveReimbursement) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[ExpenseListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取抄送给我的
 * author:SkyWork
 */
+(void)getCopyToMes:(NSDictionary *)prame
            success:(void (^)(NSArray <ExpenseListModel *>*list))success
            failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BGET:BASE_URL(getCopyToMe) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[ExpenseListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取我的报销
 * author:SkyWork
 */
+(void)getMineExpense:(NSDictionary *)prame
             success:(void (^)(NSArray <ExpenseListModel *>*list))success
             failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BGET:BASE_URL(getMineReimbursement) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[ExpenseListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 撤回报销
 * author:SkyWork
 */
+(void)deleteExpense:(NSString *)ex_id
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    NSString * urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL(officeReimbursement),ex_id];
    
    [SFBaseModel DELETE:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取报销详情
 * author:SkyWork
 */
+(void)getMineExpenseDateil:(NSString *)ex_id
                    success:(void (^)(ExpenseListModel * model,NSArray <ExpenseToWhoModel *>* list))success
                    failure:(void (^)(NSError *))failure {
    
    NSString * urlString = [NSString stringWithFormat:@"%@/%@",BASE_URL(officeReimbursement),ex_id];
    [SFBaseModel BGET:urlString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        ExpenseListModel * mod = [ExpenseListModel modelWithJSON:model.result];
        NSArray * array = [NSArray modelArrayWithClass:[ExpenseToWhoModel class] json:model.result[@"copyToWho"]];
        !success?:success(mod,array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation ExpenseListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"reimbursementItemDTOList" : [ExpenseItemModel class],
             @"reimbursementProcessDTOList" : [ExpenseProcessModel class],
             @"coToWhos" : [ExpenseToWhoModel class],
             @"reimbursementItemDTO":[ExpenseItemModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id",
             @"coToWhos":@"copyToWho",
             @"coId":@"copyToId",
             @"coIds":@"copyToIds"
             };
}

@end

@implementation ExpenseItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ExpenseProcessModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ExpenseToWhoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
