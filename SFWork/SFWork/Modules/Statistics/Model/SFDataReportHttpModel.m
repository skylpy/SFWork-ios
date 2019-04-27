//
//  SFDataReportHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDataReportHttpModel.h"

@implementation SFDataReportHttpModel

/**
 * des:统计信息
 * author:SkyWork
 */
+(void)statisticsDataReport:(NSDictionary *)prame
                    success:(void (^)(SFStatisticsModel * model))success
                    failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(dataReportStatistics) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFStatisticsModel * smodel = [SFStatisticsModel modelWithJSON:model.result];
        !success?:success(smodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:保存数据汇报模板
 * author:SkyWork
 */
+(void)addTemplateDataReport:(NSDictionary *)prame
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(dataReportTemplate) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:根据部门数据汇报模板
 * author:SkyWork
 */
+(void)templateDataReport:(NSString *)depId
                  success:(void (^)(TemplateModel * model))success
                  failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",BASE_URL(dataReportTemplate),depId];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        TemplateModel * smodel = [TemplateModel modelWithJSON:model.result];
        !success?:success(smodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:提交汇报
 * author:SkyWork
 */
+(void)submitDataReport:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(submitReportDataReport) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:根据ID获取汇报
 * author:SkyWork
 */
+(void)getDataReport:(NSString *)depId
             success:(void (^)(SFTemplateModel * model))success
             failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@/%@",BASE_URL(officeDataReport),depId];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFTemplateModel * smodel = [SFTemplateModel modelWithJSON:model.result];
        !success?:success(smodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取个人汇报历史记录
 * author:SkyWork
 */
+(void)getMyHistoryDataReport:(NSDictionary *)prame
                      success:(void (^)(NSArray <SFTemplateModel *>* list))success
                      failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(dataReportMyHistory) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFTemplateModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取员工ID获取员工汇报
 * author:SkyWork
 */
+(void)findByEmployeeDataReport:(NSDictionary *)prame
                        success:(void (^)(NSArray <SFTemplateModel *>* list))success
                        failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(dataReportFindByEmployee) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFTemplateModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取直属员工汇报列表
 * author:SkyWork
 */
+(void)getDirectlyEmployeeReportDataReport:(NSDictionary *)prame
                                   success:(void (^)(NSArray <SFTemplateModel *>* list))success
                                   failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(getDirectlyEmployeeReport) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFTemplateModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取当前周期的模板
 * author:SkyWork
 */
+(void)getDirectlyEmployeeReportSuccess:(void (^)(SFTemplateModel * model))success
                                failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BGET:BASE_URL(getCurrentReport) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFTemplateModel * models = [SFTemplateModel modelWithJSON:model.result];
        !success?:success(models);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:检查当前用户是否有审核改汇报的权限
 * author:SkyWork
 */
+(void)checkAuditPermissions:(NSString *)Id
                     success:(void (^)(NSInteger result))success
                     failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(checkAuditPermission),Id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSInteger res = [model.result[@"result"] integerValue];
        !success?:success(res);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:审核汇报
 * author:SkyWork
 */
+(void)auditDataReport:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(dataReportAudit) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:撤回汇报
 * author:SkyWork
 */
+(void)recallDataReport:(NSString *)Id
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(dataReportRecall),Id];
    [SFBaseModel BPOST:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}


@end

@implementation RatingSettingModel

+ (RatingSettingModel *)addModel {
    
    RatingSettingModel * model1 = [RatingSettingModel manageTemplateItemId:@"" withScore:@"" withValue:@"" withOperator:@"" withId:@""];
   
    return model1;
}


+ (RatingSettingModel *)manageTemplateItemId:(NSString *)templateItemId withScore:(NSString *)score withValue:(NSString *)value withOperator:(NSString *)operator withId:(NSString *)id{
    
    RatingSettingModel * model = [RatingSettingModel new];
    model.templateItemId = templateItemId;
    model.value = value;
    model.score = score;
    model.operator = operator;
    model.id = id;
    return model;
}

@end

@implementation ItemsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"ratingSettings" : [RatingSettingModel class]
             };
}

+ (ItemsModel *)addModel {
    
    ItemsModel * model1 = [ItemsModel manageTemplateId:@"" withName:@"" withUnit:@"" withTarget:@"" withRatingSettings:@[] withId:@""];
    
    return model1;
}

+ (ItemsModel *)manageTemplateId:(NSString *)templateId withName:(NSString *)name withUnit:(NSString *)unit withTarget:(NSString *)target withRatingSettings:(NSArray *)ratingSettings withId:(NSString *)id{
    
    ItemsModel * model = [ItemsModel new];
    model.templateId = templateId;
    model.name = name;
    model.unit = unit;
    model.target = target;
    model.ratingSettings = ratingSettings;
    model.id = id;
    return model;
}

@end
static TemplateModel *manager = nil;
@implementation TemplateModel

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items" : [ItemsModel class]
             };
}

@end

@implementation SFTemplateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items" : [ItemsModel class]
             };
}

@end
