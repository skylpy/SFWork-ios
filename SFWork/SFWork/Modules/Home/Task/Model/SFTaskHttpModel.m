//
//  SFTaskHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTaskHttpModel.h"

@implementation SFTaskHttpModel

/**
 * des:添加任务
 * author:SkyWork
 */
+(void)autoCreateAddTask:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(officeAddTask) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:我的任务
 * author:SkyWork
 */
+(void)getMyTaskList:(NSDictionary *)prame
             success:(void (^)(SFTaskListModel * model))success
             failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPOST:BASE_URL(myTaskList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFTaskListModel * tmodel = [SFTaskListModel modelWithJSON:model.result];
        !success?:success(tmodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:管理员查看直属员工列表
 * author:SkyWork
 */
+(void)getMyTaskManagerListSuccess:(void (^)(SFTaskListModel * model))success
                           failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(taskManager) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFTaskListModel * tmodel = [SFTaskListModel modelWithJSON:model.result];
        !success?:success(tmodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取任务详情
 * author:SkyWork
 */
+(void)getMyTaskManager:(NSString *)taskId
                success:(void (^)(TaskListModel * model))success
                failure:(void (^)(NSError *))failure{
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(taskDetail),taskId];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        TaskListModel * tmodel = [TaskListModel modelWithJSON:model.result];
        !success?:success(tmodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改任务状态
 * author:SkyWork
 */
+(void)putMyTaskManager:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPUT:BASE_URL(changeTaskStatus) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:删除任务
 * author:SkyWork
 */
+(void)deleteMyTaskManager:(NSDictionary *)prame
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure{
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(deleteTask),prame[@"id"]];
    [SFBaseModel DELETE:URLString parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:提交任务总结
 * author:SkyWork
 */
+(void)putMyTaskSummary:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(submitTaskSummary) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:修改任务审批状态
 * author:SkyWork
 */
+(void)putMyTaskStatus:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(changeAuditTaskStatus) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:任务搜索
 * author:SkyWork
 */
+(void)searchOfficeTask:(NSDictionary *)prame
                success:(void (^)(NSArray <TaskListModel *> *list))success
                failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(searchTask) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[TaskListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation SFTaskListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"PROCEED" : [TaskListModel class],
             @"UNPROVED" : [TaskListModel class],
             @"ACCOMPLISH" : [TaskListModel class],
             @"UNACCOMPLISHED" : [TaskListModel class],
             @"APPROVED":[TaskListModel class],
             @"RESULT":[TaskListModel class]
             };
}


@end

static TaskListModel *manager = nil;
@implementation TaskListModel

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
