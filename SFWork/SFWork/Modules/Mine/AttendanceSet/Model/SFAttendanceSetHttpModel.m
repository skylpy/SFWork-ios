//
//  SFAttendanceSetHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceSetHttpModel.h"

@implementation SFAttendanceSetHttpModel

/**
 * des:获取自己公司的考勤模板列表
 * author:SkyWork
 */
+(void)getTemplateListSuccess:(void (^)(NSArray <SFAttendanceModel *> * list))success
                      failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BGET:BASE_URL(attendanceGetTemplateList) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFAttendanceModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取考勤模板详情
 * author:SkyWork
 */
+(void)getTemplateDateil:(NSString *)templateId
                 success:(void (^)(SFAttendanceModel * model))success
                 failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(attendanceTemplateDetail),templateId];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFAttendanceModel * amodel = [SFAttendanceModel modelWithJSON:model.result];;
        !success?:success(amodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:新增保存考勤模板
 * author:SkyWork
 */
+(void)saveTemplate:(NSDictionary *)prame
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(attendanceSaveTemplate) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}



@end

@implementation SFAttendanceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceDateDTOList" : [AttendanceDateModel class],
             @"attendancePersonnelDTOList" : [AttendancePersonnelModel class],
             @"specialDateDTOList" : [SpecialDateModel class],
             @"addressDTOList" : [SFAddressModel class],
             @"reportUserList" : [ReportUserModel class]
             };
}

@end


@implementation AttendanceDateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceTimeDTOList" : [AttendanceTimeModel class]
             };
}

@end

@implementation AttendanceTimeModel


@end

@implementation AttendancePersonnelModel


@end

@implementation SpecialDateModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"attendanceTimeDTOList" : [AttendanceTimeModel class]
             };
}

@end

@implementation SFAddressModel


@end

@implementation ReportUserModel


@end
