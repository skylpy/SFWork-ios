//
//  SFMyAttendanceHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/10.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MyAttendanceDateModel,MyAttendancePersonnelModel,MySpecialDateModel,MyAddressModel,MyAttendanModel,MyNextAttendanceModel,MyReportUserModel,MyAttendanceTimeModel,MyAttendanceModel,MyAttendanceGetRecord,MyAttendanceStatisticsModel,AttendanceStatisticsModel;
@interface SFMyAttendanceHttpModel : NSObject

/**
 * des: 获取考勤规则
 * author:SkyWork
 */
+(void)getAttendanceRulesSuccess:(void (^)(MyAttendanceModel * model))success
                         failure:(void (^)(NSError *))failure;

/**
 * des:打卡
 * author:SkyWork
 */
+(void)timeRecord:(NSDictionary *)prame
          success:(void (^)(MyAttendanceGetRecord * mode))success
          failure:(void (^)(NSError *))failure ;

/**
 * des:获取打卡记录
 * author:SkyWork
 */
+(void)getPunchCarkRecord:(NSDictionary *)prame
                  success:(void (^)(NSArray <MyAttendanceGetRecord *>* list))success
                  failure:(void (^)(NSError *))failure;

/**
 * des: 查看打卡详情
 * author:SkyWork
 */
+(void)getAttendanceRulesId:(NSString *)p_id
                    success:(void (^)(MyAttendanceGetRecord * model))success
                    failure:(void (^)(NSError *))failure;
/**
 * des:更新打卡
 * author:SkyWork
 */
+(void)updateTimeRecord:(NSDictionary *)prame
                success:(void (^)(MyAttendanceGetRecord * mode))success
                failure:(void (^)(NSError *))failure;

/**
 * des:考勤统计
 * author:SkyWork
 */
+(void)getAttendanceStatistics:(NSDictionary *)prame
                       success:(void (^)(MyAttendanceStatisticsModel *model))success
                       failure:(void (^)(NSError *))failure;

/**
 * des:考勤统计列表
 * author:SkyWork
 */
+(void)getAttendanceStatisticsList:(NSDictionary *)prame
                           success:(void (^)(NSArray <MyAttendanceStatisticsModel *>*list))success
                           failure:(void (^)(NSError *))failure;

+(void)attendanceStatisticsByChecks:(NSDictionary *)prame
                            success:(void (^)(NSArray <AttendanceStatisticsModel *>*list))success
                            failure:(void (^)(NSError *))failure ;
/**
 * des:考勤统计列表
 * author:SkyWork
 */
+(void)attendanceStatisticsByApprovals:(NSDictionary *)prame
                               success:(void (^)(NSArray <AttendanceStatisticsModel *>*list))success
                               failure:(void (^)(NSError *))failure ;

@end

@interface MyAttendanceStatisticsModel : NSObject
//出差的
@property (nonatomic, copy) NSString *BUSINESS_TRAVEL;
//迟到的
@property (nonatomic, copy) NSString *LATE;
//早退
@property (nonatomic, copy) NSString *EARLY;
//请假
@property (nonatomic, copy) NSString *LEAVE;
//异常数
@property (nonatomic, copy) NSString *ABNORMAL;
//漏卡的
@property (nonatomic, copy) NSString *MISSING;
//加班的
@property (nonatomic, copy) NSString *OVERTIME;
//正常数
@property (nonatomic, copy) NSString *NORMAL;
//外出的
@property (nonatomic, copy) NSString *OUT;


@end

@interface AttendanceStatisticsModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *attendanceStatus;
@property (nonatomic, copy) NSString *positionId;
@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, copy) NSString *attendanceTargetType;
@property (nonatomic, copy) NSString *today;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *attendanceType;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *qcreateTime;
@property (nonatomic, copy) NSString *_id;

@property (nonatomic, copy) NSString *leaveId;
@property (nonatomic, copy) NSString *leaveName;
@property (nonatomic, copy) NSString *applicationType;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *cause;
@property (nonatomic, copy) NSString *createId;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *withdraw;
@property (nonatomic, copy) NSString *applicationStatus;

@property (nonatomic, copy) NSString *smallAvatar;


@end

@interface MyAttendanceModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <MyAttendanceDateModel *> *attendanceDateDTOList;
@property (nonatomic, copy) NSArray <MyAttendancePersonnelModel *> *attendancePersonnelDTOList;
@property (nonatomic, copy) NSArray <MySpecialDateModel *> *specialDateDTOList;
@property (nonatomic, copy) NSArray <MyAddressModel *> *addressDTOList;
@property (nonatomic, copy) NSArray <MyReportUserModel *> *reportUserList;
@property (nonatomic, strong) MyAttendanModel *attendanceDTOS;
@property (nonatomic, strong) MyNextAttendanceModel *nextAttendanceDTOS;

@property (nonatomic, copy) NSString *startRemind;
@property (nonatomic, copy) NSString *endRemind;
@property (nonatomic, assign) BOOL holidays;
@property (nonatomic, assign) BOOL photoCheck;
@property (nonatomic, copy) NSString *today;
@property (nonatomic, copy) NSString *checkInNum;
@property (nonatomic, copy) NSString *permissionType;

//打卡按钮" GOTOWORK("上班"),OFFDUTY("下班"), UPDATE("更新")
@property (nonatomic, copy) NSString *attendances;

@property (nonatomic, copy) NSString *_id;

@end

@interface MyAttendanceDateModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSArray <MyAttendanceTimeModel *> *attendanceTimeDTOList;
@property (nonatomic, copy) NSArray *days;
@property (nonatomic, copy) NSString *absenteeismMinutes;
@property (nonatomic, copy) NSString *beforeMinutes;
@property (nonatomic, copy) NSString *lateMinutes;
@property (nonatomic, copy) NSString *earlyMinutes;
@property (nonatomic, copy) NSString *resetTime;
@property (nonatomic, copy) NSString *resetDate;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;


@end

@interface MyAttendanceTimeModel : NSObject

@property (nonatomic, copy) NSString *attendanceDateId;
@property (nonatomic, copy) NSString *specialDateId;
@property (nonatomic, copy) NSString *timeNumber;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *startNextDay;
@property (nonatomic, copy) NSString *endNextDay;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

@end

@interface MyAttendancePersonnelModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, copy) NSString *attendanceTargetType;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

@end

@interface MySpecialDateModel : NSObject

@property (nonatomic, copy) NSString *specialDate;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *specialDateType;
@property (nonatomic, copy) NSArray <MyAttendanceTimeModel *> *attendanceTimeDTOList;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

@end

@interface MyAddressModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *addresskeyword;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

@end

@interface MyAttendanModel : NSObject

@property (nonatomic, copy) NSString *attendances;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *millisecond;
@property (nonatomic, copy) NSString *timeNumber;
@property (nonatomic, copy) NSString *beforeMinutes;

@end

@interface MyNextAttendanceModel : NSObject

@end

@interface MyReportUserModel : NSObject

@end


@interface MyAttendanceGetRecord : NSObject

@property (nonatomic, copy) NSString *attendanceType;
@property (nonatomic, copy) NSString *attendanceStatus;
@property (nonatomic, copy) NSString *auditStatus;
@property (nonatomic, copy) NSString *positioningType;
@property (nonatomic, copy) NSString *attendances;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *checkInDate;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *refuse;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *timeNumber;

@property (nonatomic, copy) NSString *violationTime;

@end

NS_ASSUME_NONNULL_END
