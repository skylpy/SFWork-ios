//
//  SFWorkAssessHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssessHttpModel.h"


@implementation SFWorkAssessHttpModel

/**
 * des:新增考核规则
 * author:SkyWork
 */
+(void)addWorkAssessCheck:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(checkModulesRule) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:考核规则搜索
 * author:SkyWork
 */
+(void)workAssessCheckSearch:(NSDictionary *)prame
                     success:(void (^)(NSArray <SFWorkCheckItemModel *>*list))success
                     failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(checkModulesSearch) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(30)
        NSArray *array = [NSArray modelArrayWithClass:[SFWorkCheckItemModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取考核模块列表
 * author:SkyWork
 */
+(void)workAssessCheckList:(NSDictionary *)prame
                   success:(void (^)(NSArray <SFWorkAssessItemModel *>*list))success
                   failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BGET:BASE_URL(checkModules) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(25)
        NSArray *array = [NSArray modelArrayWithClass:[SFWorkAssessItemModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取考核项列表
 * author:SkyWork
 */
+(void)workAssessCheckModule:(NSString *)module
                     success:(void (^)(NSArray <SFWorkCheckItemModel *>*list))success
                     failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(checkModulesItem),module];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(18)
        NSArray *array = [NSArray modelArrayWithClass:[SFWorkCheckItemModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
* des: 删除考核规则
* author:SkyWork
*/
+(void)workAssessDeleteCheckModule:(NSDictionary *)k_id
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(checkModulesRuleDel),k_id];
    [SFBaseModel DELETE:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 获取某人某月的考核分数
 * author:SkyWork
 */
+(void)getWorkAssessCheckPrame:(NSDictionary *)prame
                       success:(void (^)(SFWorkAssessPersonModel * model))success
                       failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(checkModulesRuleScore) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFWorkAssessPersonModel *mode = [SFWorkAssessPersonModel modelWithJSON:model.result];
        !success?:success(mode);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 考核分数处理
 * author:SkyWork
 */
+(void)postWorkAssessCheckAssessId:(NSString *)assessId
                       withProcess:(NSDictionary *)prame
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@/process",BASE_URL(checkModulesRuleScore),assessId];
    [SFBaseModel BPOST:URLString parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation SFWorkAssessItemModel


@end

@implementation SFWorkCheckItemModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"itemSubList" : [ItemSubListModel class],
             @"rulePersonDTOList" : [RulePersonModel class],
             @"ruleItemDTOList" : [RuleModulesItemModel class],
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ItemSubListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation RulePersonModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation RuleModulesItemModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"itemSubList" : [ItemSubListModel class]
             };
}

@end
