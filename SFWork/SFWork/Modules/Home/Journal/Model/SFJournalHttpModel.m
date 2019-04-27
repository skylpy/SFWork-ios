//
//  SFJournalHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalHttpModel.h"

@implementation SFJournalHttpModel

/**
 * des:新增日报
 * author:SkyWork
 */
+(void)addCompanyJournal:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(officeDaily) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:添加日报管理模板
 * author:SkyWork
 */
+(void)autoCreateDailyTemplates:(NSString *)uid
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *))failure{
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",BASE_URL(autoCreateDailyTemplate),uid];
    [SFBaseModel BPOST:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}


/**
 * des:获取直属下属日报
 * author:SkyWork
 */
+(void)getManagerLists:(NSDictionary *)prame
               success:(void (^)(NSArray <SFJournalListModel *>*list))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(getManagerDailyList) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFJournalListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取自己的日报
 * author:SkyWork
 */
+(void)getMyDailyLists:(NSDictionary *)prame
               success:(void (^)(NSArray <SFJournalListModel *>*list))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(getMyDailyList) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFJournalListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取自己的日报模版
 * author:SkyWork
 */
+(void)getMyTemplateListsSuccess:(void (^)(SFJournalSetModel * model))success
                         failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(getMyTemplate) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFJournalSetModel * smodel = [SFJournalSetModel modelWithJSON:model.result];
        !success?:success(smodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:根据条件查询日报
 * author:SkyWork
 */
+(void)getSearchDailyList:(NSDictionary *)prame
                  success:(void (^)(NSArray <SFJournalListModel *>*list))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(searchDailyList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFJournalListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改日报未读状态
 * author:SkyWork
 */
+(void)putDailyUpdate:(NSString *)uid
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure{
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(dailyUpdate),uid];
    [SFBaseModel BPUT:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:查看日报详情
 * author:SkyWork
 */
+(void)getDailyDetails:(NSString *)uid
               success:(void (^)(SFJournalListModel * smodel))success
               failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(dailyDetails),uid];
    [SFBaseModel BPOST:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFJournalListModel * jmodel = [SFJournalListModel modelWithJSON:model.result];
        !success?:success(jmodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改日报审批状态
 * author:SkyWork
 */
+(void)changeAuditStatuss:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    

    [SFBaseModel BPUT:BASE_URL(changeAuditStatus) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改日报设置
 * author:SkyWork
 */
+(void)updateDailySettings:(NSDictionary *)prame
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPUT:BASE_URL(updateDailySetting) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}


@end

@implementation SFJournalListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"dailyAuditUserList" : [AuditUser class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation AuditUser


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
