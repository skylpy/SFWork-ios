//
//  SFDataReportHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFStatisticsModel.h"
NS_ASSUME_NONNULL_BEGIN

@class TemplateModel,SFTemplateModel;
@interface SFDataReportHttpModel : NSObject

/**
 * des:统计信息
 * author:SkyWork
 */
+(void)statisticsDataReport:(NSDictionary *)prame
                    success:(void (^)(SFStatisticsModel * model))success
                    failure:(void (^)(NSError *))failure;

/**
 * des:保存数据汇报模板
 * author:SkyWork
 */
+(void)addTemplateDataReport:(NSDictionary *)prame
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure ;

/**
 * des:根据部门数据汇报模板
 * author:SkyWork
 */
+(void)templateDataReport:(NSString *)depId
                  success:(void (^)(TemplateModel * model))success
                  failure:(void (^)(NSError *))failure ;
/**
 * des:提交汇报
 * author:SkyWork
 */
+(void)submitDataReport:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:根据ID获取汇报
 * author:SkyWork
 */
+(void)getDataReport:(NSString *)depId
             success:(void (^)(SFTemplateModel * model))success
             failure:(void (^)(NSError *))failure;

/**
 * des:获取个人汇报历史记录
 * author:SkyWork
 */
+(void)getMyHistoryDataReport:(NSDictionary *)prame
                      success:(void (^)(NSArray <SFTemplateModel *>* list))success
                      failure:(void (^)(NSError *))failure ;

/**
 * des:获取直属员工汇报列表
 * author:SkyWork
 */
+(void)getDirectlyEmployeeReportDataReport:(NSDictionary *)prame
                                   success:(void (^)(NSArray <SFTemplateModel *>* list))success
                                   failure:(void (^)(NSError *))failure ;

/**
 * des:获取当前周期的模板
 * author:SkyWork
 */
+(void)getDirectlyEmployeeReportSuccess:(void (^)(SFTemplateModel * model))success
                                failure:(void (^)(NSError *))failure ;

/**
 * des:检查当前用户是否有审核改汇报的权限
 * author:SkyWork
 */
+(void)checkAuditPermissions:(NSString *)Id
                     success:(void (^)(NSInteger result))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:审核汇报
 * author:SkyWork
 */
+(void)auditDataReport:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

/**
 * des:撤回汇报
 * author:SkyWork
 */
+(void)recallDataReport:(NSString *)Id
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure ;

/**
 * des:获取员工ID获取员工汇报
 * author:SkyWork
 */
+(void)findByEmployeeDataReport:(NSDictionary *)prame
                        success:(void (^)(NSArray <SFTemplateModel *>* list))success
                        failure:(void (^)(NSError *))failure;
@end



@interface RatingSettingModel : NSObject

@property (nonatomic, copy) NSString *templateItemId;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *operator;
@property (nonatomic, copy) NSString *id;

+ (RatingSettingModel *)addModel;

@end

@interface ItemsModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSArray <RatingSettingModel *>*ratingSettings;
@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *dataReportId;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *templateItemId;

+ (ItemsModel *)addModel;

@end

@interface TemplateModel : NSObject

@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *period;
@property (nonatomic, copy) NSArray <NSString *>*days;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *startDateTimeStr;
@property (nonatomic, copy) NSString *endDateTimeStr;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *remindContext;
@property (nonatomic, assign) BOOL remindNotification;
@property (nonatomic, copy) NSString *remindTime;
@property (nonatomic, copy) NSArray <ItemsModel *> *items;
@property (nonatomic, copy) NSString *id;
+ (instancetype)shareManager;
@end

@interface SFTemplateModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *employeeAvatar;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSArray <ItemsModel *>*items;
@property (nonatomic, copy) NSArray *employeeIds;
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
