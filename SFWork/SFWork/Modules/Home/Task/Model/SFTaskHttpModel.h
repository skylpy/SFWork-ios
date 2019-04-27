//
//  SFTaskHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TaskListModel,SFTaskListModel;
@interface SFTaskHttpModel : NSObject

/**
 * des:添加任务
 * author:SkyWork
 */
+(void)autoCreateAddTask:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:我的任务
 * author:SkyWork
 */
+(void)getMyTaskList:(NSDictionary *)prame
             success:(void (^)(SFTaskListModel * model))success
             failure:(void (^)(NSError *))failure;

/**
 * des:管理员查看直属员工列表
 * author:SkyWork
 */
+(void)getMyTaskManagerListSuccess:(void (^)(SFTaskListModel * model))success
                           failure:(void (^)(NSError *))failure;

/**
 * des:获取任务详情
 * author:SkyWork
 */
+(void)getMyTaskManager:(NSString *)taskId
                success:(void (^)(TaskListModel * model))success
                failure:(void (^)(NSError *))failure;

/**
 * des:修改任务状态
 * author:SkyWork
 */
+(void)putMyTaskManager:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:删除任务
 * author:SkyWork
 */
+(void)deleteMyTaskManager:(NSDictionary *)prame
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure;

/**
 * des:提交任务总结
 * author:SkyWork
 */
+(void)putMyTaskSummary:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:修改任务审批状态
 * author:SkyWork
 */
+(void)putMyTaskStatus:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

/**
 * des:任务搜索
 * author:SkyWork
 */
+(void)searchOfficeTask:(NSDictionary *)prame
                success:(void (^)(NSArray <TaskListModel *> *list))success
                failure:(void (^)(NSError *))failure;

@end

@interface SFTaskListModel : NSObject

//进行中
@property (nonatomic, strong) NSArray <TaskListModel *>*PROCEED;
//待进行
@property (nonatomic, strong) NSArray <TaskListModel *>*UNPROVED;
//完成
@property (nonatomic, strong) NSArray <TaskListModel *>*ACCOMPLISH;
//未完成
@property (nonatomic, strong) NSArray <TaskListModel *>*UNACCOMPLISHED;

//完成和未完成的
@property (nonatomic, strong) NSArray <TaskListModel *>*RESULT;
//已审批的
@property (nonatomic, strong) NSArray <TaskListModel *>*APPROVED;

@end

@interface TaskListModel : NSObject

//
@property (nonatomic, copy) NSArray *summarizePhotos;
@property (nonatomic, copy) NSString *taskNumber;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *taskTypeId;
@property (nonatomic, copy) NSString *taskTypeName;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *taskStatus;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *accomplishTime;
@property (nonatomic, copy) NSString *summarize;

@property (nonatomic, copy) NSArray *photos;

@property (nonatomic, copy) NSArray *auditUserList;
@property (nonatomic, copy) NSString *executorName;
@property (nonatomic, copy) NSString *executorId;
@property (nonatomic, copy) NSString *createId;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *companyId;

+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
