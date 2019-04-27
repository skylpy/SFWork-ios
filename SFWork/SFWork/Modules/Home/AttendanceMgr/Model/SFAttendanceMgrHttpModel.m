//
//  SFAttendanceMgrHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/9.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttendanceMgrHttpModel.h"

@implementation SFAttendanceMgrHttpModel

/**
 * des: 发起列表
 * author:SkyWork
 */
+(void)getMyApproval:(NSDictionary *)prame
             success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
             failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BPOST:BASE_URL(approvalMyApprovalList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * list = [NSArray modelArrayWithClass:[BusinessTripLeaveOvertimeModel class] json:model.result[@"list"]];
        !success?:success(list);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 审批列表
 * author:SkyWork
 */
+(void)getMyManager:(NSDictionary *)prame
            success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
            failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BPOST:BASE_URL(approvalManagerList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * list = [NSArray modelArrayWithClass:[BusinessTripLeaveOvertimeModel class] json:model.result[@"list"]];
        !success?:success(list);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 抄送列表
 * author:SkyWork
 */
+(void)getMyCopyList:(NSDictionary *)prame
             success:(void (^)(NSArray <BusinessTripLeaveOvertimeModel *> * list))success
             failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BGET:BASE_URL(approvalCopyList) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * list = [NSArray modelArrayWithClass:[BusinessTripLeaveOvertimeModel class] json:model.result[@"list"]];
        !success?:success(list);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:发起申请
 * author:SkyWork
 */
+(void)submitApproval:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(SenderApproval) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 申请详情
 * author:SkyWork
 */
+(void)getApprovalDetails:(NSString *)a_id
                  success:(void (^)(ApprovalDetailsModel * model))success
                  failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(approvalDetails),a_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        ApprovalDetailsModel * mode = [ApprovalDetailsModel modelWithJSON:model.result];;
        !success?:success(mode);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 撤回申请
 * author:SkyWork
 */
+(void)getApprovalRecalls:(NSString *)a_id
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(approvalDetails),a_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des: 通过申请
 * author:SkyWork
 */
+(void)getApprovalAdopt:(NSString *)a_id
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(approvalAgreement),a_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:拒绝申请
 * author:SkyWork
 */
+(void)rejectApproval:(NSDictionary *)prame
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(approvalOverruled) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation AttendanceMgrModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"BUSINESS_TRAVEL" : [BusinessTripLeaveOvertimeModel class],
             @"LEAVE" : [BusinessTripLeaveOvertimeModel class],
             @"OVERTIME" : [BusinessTripLeaveOvertimeModel class]
             };
}

@end

@implementation BusinessTripLeaveOvertimeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ApprovalDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"copToId" : [CopyToIdModel class],
             @"approvalProcessDTOS" : [ApprovalProcessModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id",
             @"copToId":@"copyToId",
             @"copToIds":@"copyToIds",
             
             };
}

@end

@implementation CopyToIdModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ApprovalProcessModel


@end

