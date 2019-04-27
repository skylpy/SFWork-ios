//
//  SFJournalHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFJournalSetModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SFJournalListModel,AuditUser;
@interface SFJournalHttpModel : NSObject

/**
 * des:新增日报
 * author:SkyWork
 */
+(void)addCompanyJournal:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:添加日报管理模板
 * author:SkyWork
 */
+(void)autoCreateDailyTemplates:(NSString *)uid
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *))failure;

/**
 * des:获取自己的日报
 * author:SkyWork
 */
+(void)getMyDailyLists:(NSDictionary *)prame
               success:(void (^)(NSArray <SFJournalListModel *>*list))success
               failure:(void (^)(NSError *))failure;

/**
 * des:获取直属下属日报
 * author:SkyWork
 */
+(void)getManagerLists:(NSDictionary *)prame
               success:(void (^)(NSArray <SFJournalListModel *>*list))success
               failure:(void (^)(NSError *))failure;

/**
 * des:获取自己的日报模版
 * author:SkyWork
 */
+(void)getMyTemplateListsSuccess:(void (^)(SFJournalSetModel * model))success
                         failure:(void (^)(NSError *))failure;

/**
 * des:根据条件查询日报
 * author:SkyWork
 */
+(void)getSearchDailyList:(NSDictionary *)prame
                  success:(void (^)(NSArray <SFJournalListModel *>*list))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:修改日报未读状态
 * author:SkyWork
 */
+(void)putDailyUpdate:(NSString *)uid
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure;

/**
 * des:查看日报详情
 * author:SkyWork
 */
+(void)getDailyDetails:(NSString *)uid
               success:(void (^)(SFJournalListModel * smodel))success
               failure:(void (^)(NSError *))failure;

/**
 * des:修改日报审批状态
 * author:SkyWork
 */
+(void)changeAuditStatuss:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure ;

/**
 * des:修改日报设置
 * author:SkyWork
 */
+(void)updateDailySettings:(NSDictionary *)prame
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *))failure ;


@end

@interface SFJournalListModel : NSObject

@property (nonatomic, copy) NSString *dailyType;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, copy) NSString *createId;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *auditUserListIds;
@property (nonatomic, copy) NSString *auditUserId;
@property (nonatomic, copy) NSString *dailyStatus;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *qcreateTime;
@property (nonatomic, strong) NSArray <AuditUser *> * dailyAuditUserList;


@end

@interface AuditUser : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;

@end

NS_ASSUME_NONNULL_END
