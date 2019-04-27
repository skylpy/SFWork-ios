//
//  SFMyAttendanceHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/10.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMyAttendanceHttpModel.h"

@implementation SFMyAttendanceHttpModel

/**
 * des: 获取考勤规则
 * author:SkyWork
 */
+(void)getAttendanceRulesSuccess:(void (^)(MyAttendanceModel * model))success
                         failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BGET:BASE_URL(attendanceGetRules) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        MyAttendanceModel * mod = [MyAttendanceModel modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:打卡
 * author:SkyWork
 */
+(void)timeRecord:(NSDictionary *)prame
              success:(void (^)(MyAttendanceGetRecord * mode))success
              failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceTimeRecord) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(25)
        MyAttendanceGetRecord * mod = [MyAttendanceGetRecord modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
* des:更新打卡
* author:SkyWork
*/
+(void)updateTimeRecord:(NSDictionary *)prame
                success:(void (^)(MyAttendanceGetRecord * mode))success
                failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceUpdateRecord) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        MyAttendanceGetRecord * mod = [MyAttendanceGetRecord modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:获取打卡记录
 * author:SkyWork
 */
+(void)getPunchCarkRecord:(NSDictionary *)prame
                  success:(void (^)(NSArray <MyAttendanceGetRecord *>* list))success
                  failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceGetRecord) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[MyAttendanceGetRecord class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 查看打卡详情
 * author:SkyWork
 */
+(void)getAttendanceRulesId:(NSString *)p_id
                    success:(void (^)(MyAttendanceGetRecord * model))success
                    failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(attendanceAuditUpdate),p_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        MyAttendanceGetRecord * mod = [MyAttendanceGetRecord modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:考勤统计
 * author:SkyWork
 */
+(void)getAttendanceStatistics:(NSDictionary *)prame
                       success:(void (^)(MyAttendanceStatisticsModel *model))success
                       failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceStatistics) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        MyAttendanceStatisticsModel *mod = [MyAttendanceStatisticsModel modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}
//

/**
 * des:考勤统计列表
 * author:SkyWork
 */
+(void)getAttendanceStatisticsList:(NSDictionary *)prame
                           success:(void (^)(NSArray <MyAttendanceStatisticsModel *>*list))success
                           failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceStatisticsList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray *array = [NSArray modelArrayWithClass:[MyAttendanceStatisticsModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:考勤统计列表
 * author:SkyWork
 */
+(void)attendanceStatisticsByChecks:(NSDictionary *)prame
                            success:(void (^)(NSArray <AttendanceStatisticsModel *>*list))success
                            failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceStatisticsByCheck) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray *array = [NSArray modelArrayWithClass:[AttendanceStatisticsModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:考勤统计列表
 * author:SkyWork
 */
+(void)attendanceStatisticsByApprovals:(NSDictionary *)prame
                               success:(void (^)(NSArray <AttendanceStatisticsModel *>*list))success
                               failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceStatisticsByApproval) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(20)
        NSArray *array = [NSArray modelArrayWithClass:[AttendanceStatisticsModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation MyAttendanceStatisticsModel

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//
//    return @{@"BUSINESS_TRAVEL" : [AttendanceStatisticsModel class],
//             @"LATE" : [AttendanceStatisticsModel class],
//             @"EARLY" : [AttendanceStatisticsModel class],
//             @"LEAVE" : [AttendanceStatisticsModel class],
//             @"MISSING" : [AttendanceStatisticsModel class],
//             @"OUT" : [AttendanceStatisticsModel class],
//             @"OVERTIME" : [AttendanceStatisticsModel class]
//             };
//}

@end

@implementation AttendanceStatisticsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end

@implementation MyAttendanceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceDateDTOList" : [MyAttendanceDateModel class],
             @"attendancePersonnelDTOList" : [MyAttendancePersonnelModel class],
             @"specialDateDTOList" : [MySpecialDateModel class],
             @"addressDTOList" : [MyAddressModel class],
             @"reportUserList" : [MyReportUserModel class],
             @"attendanceDTOS" : [MyAttendanModel class],
             @"nextAttendanceDTOS" : [MyNextAttendanceModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation MyAttendanceDateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceTimeDTOList" : [MyAttendanceTimeModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation MyAttendanceTimeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end

@implementation MyAttendancePersonnelModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end

@implementation MySpecialDateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceTimeDTOList" : [MyAttendanceTimeModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}


@end

@implementation MyAddressModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation MyAttendanModel


@end

@implementation MyNextAttendanceModel


@end

@implementation MyReportUserModel


@end

@implementation MyAttendanceGetRecord

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
