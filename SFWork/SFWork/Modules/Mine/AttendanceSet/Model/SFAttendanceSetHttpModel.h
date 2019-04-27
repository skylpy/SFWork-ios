//
//  SFAttendanceSetHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFAttendanceModel, AttendanceTimeModel,AttendanceDateModel,AttendancePersonnelModel
,SpecialDateModel,SFAddressModel,ReportUserModel;
@interface SFAttendanceSetHttpModel : NSObject

/**
 * des:获取自己公司的考勤模板列表
 * author:SkyWork
 */
+(void)getTemplateListSuccess:(void (^)(NSArray <SFAttendanceModel *> * list))success
                      failure:(void (^)(NSError *))failure;

/**
 * des:获取考勤模板详情
 * author:SkyWork
 */
+(void)getTemplateDateil:(NSString *)templateId
                 success:(void (^)(SFAttendanceModel * model))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:新增保存考勤模板
 * author:SkyWork
 */
+(void)saveTemplate:(NSDictionary *)prame
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure ;

@end

@interface SFAttendanceModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray <AttendanceDateModel *> *attendanceDateDTOList;
@property (nonatomic, copy) NSArray <AttendancePersonnelModel *>*attendancePersonnelDTOList;
@property (nonatomic, copy) NSArray <SpecialDateModel *>*specialDateDTOList;
@property (nonatomic, copy) NSArray <SFAddressModel *>*addressDTOList;
@property (nonatomic, copy) NSArray <ReportUserModel *>*reportUserList;
@property (nonatomic, copy) NSString * startRemind;
@property (nonatomic, copy) NSString * endRemind;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL holidays;
@property (nonatomic, assign) BOOL photoCheck;

@end


@interface AttendanceDateModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSArray *days;
@property (nonatomic, copy) NSString *minutes;
@property (nonatomic, copy) NSString *beforeMinutes;
@property (nonatomic, copy) NSString *resetTime;
@property (nonatomic, copy) NSString *absenteeismMinutes;
@property (nonatomic, copy) NSString *lateMinutes;
@property (nonatomic, copy) NSString *earlyMinutes;
@property (nonatomic, strong) NSArray <AttendanceTimeModel *>*attendanceTimeDTOList;
@property (nonatomic, copy) NSString *id;

@end

@interface AttendanceTimeModel : NSObject

@property (nonatomic, copy) NSString *attendanceDateId;
@property (nonatomic, copy) NSString *specialDateId;
@property (nonatomic, copy) NSString *timeNumber;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end

@interface AttendancePersonnelModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *targetId;
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, copy) NSString *attendanceTargetType;

@end

@interface SpecialDateModel : NSObject

@property (nonatomic, copy) NSString *specialDate;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *specialDateType;
@property (nonatomic, copy) NSArray <AttendanceTimeModel *>*attendanceTimeDTOList;

@end

@interface SFAddressModel : NSObject

@property (nonatomic, copy) NSString *templateId;
@property (nonatomic, copy) NSString *addresskeyword;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *createTime;

@end

@interface ReportUserModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *smallAvatar;

@end

NS_ASSUME_NONNULL_END
