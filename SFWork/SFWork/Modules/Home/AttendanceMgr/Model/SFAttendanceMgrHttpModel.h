//
//  SFAttendanceMgrHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BusinessTripLeaveOvertimeModel,AttendanceMgrModel,CopyToIdModel,ApprovalProcessModel,ApprovalDetailsModel;
@interface SFAttendanceMgrHttpModel : NSObject

/**
 * des: 发起列表
 * author:SkyWork
 */
+(void)getMyApproval:(NSDictionary *)prame
             success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
             failure:(void (^)(NSError *))failure ;

/**
 * des: 审批列表
 * author:SkyWork
 */
+(void)getMyManager:(NSDictionary *)prame
            success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
            failure:(void (^)(NSError *))failure ;

/**
 * des: 抄送列表
 * author:SkyWork
 */
+(void)getMyCopyList:(NSDictionary *)prame
             success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
             failure:(void (^)(NSError *))failure ;

/**
 * des:发起申请
 * author:SkyWork
 */
+(void)submitApproval:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure;

/**
 * des: 申请详情
 * author:SkyWork
 */
+(void)getApprovalDetails:(NSString *)a_id
                  success:(void (^)(ApprovalDetailsModel * model))success
                  failure:(void (^)(NSError *))failure;

/**
 * des: 撤回申请
 * author:SkyWork
 */
+(void)getApprovalRecalls:(NSString *)a_id
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des: 通过申请
 * author:SkyWork
 */
+(void)getApprovalAdopt:(NSString *)a_id
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure ;

/**
 * des:拒绝申请
 * author:SkyWork
 */
+(void)rejectApproval:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure ;

@end

@interface AttendanceMgrModel : NSObject

@property (nonatomic, copy) NSArray <BusinessTripLeaveOvertimeModel *> *BUSINESS_TRAVEL;
@property (nonatomic, copy) NSArray <BusinessTripLeaveOvertimeModel *> *LEAVE;
@property (nonatomic, copy) NSArray <BusinessTripLeaveOvertimeModel *> *OVERTIME;

@end

@interface BusinessTripLeaveOvertimeModel : NSObject

@property (nonatomic, copy) NSString *applicationType;
@property (nonatomic, copy) NSString *applicationStatus;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *withdraw;
@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *auditStatus;

@end

@interface ApprovalDetailsModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *leaveId;
@property (nonatomic, copy) NSString *leaveName;
@property (nonatomic, copy) NSString *applicationType;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *cause;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSArray <CopyToIdModel *> *copToId;
@property (nonatomic, copy) NSString *copToIds;
@property (nonatomic, copy) NSArray <ApprovalProcessModel *> *approvalProcessDTOS;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *createId;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *withdraw;
@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *applicationStatus;
@property (nonatomic, copy) NSString *createTime;

@end

@interface CopyToIdModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *smallAvatar;

@end

@interface ApprovalProcessModel : NSObject

@property (nonatomic, copy) NSString *approvalId;
@property (nonatomic, copy) NSString *auditUserId;
@property (nonatomic, copy) NSString *auditUserName;
@property (nonatomic, copy) NSString *approvalNum;
@property (nonatomic, copy) NSString *applicationStatus;
@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSString *smallAvatar;

@end

NS_ASSUME_NONNULL_END
