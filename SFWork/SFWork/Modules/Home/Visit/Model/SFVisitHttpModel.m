//
//  SFVisitHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitHttpModel.h"
#import "SFStatisticsModel.h"

@implementation SFVisitHttpModel

/**
 * des:添加客户拜访
 * author:SkyWork
 */
+(void)addClientVisit:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(clientVisiting) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:客户拜访列表
 * author:SkyWork
 */
+(void)clientVisitList:(NSDictionary *)prame
               success:(void (^)(NSArray <SFVisitListModel *>*list))success
               failure:(void (^)(NSError *))failure {
    NSLog(@"%@==== %@",BASE_URL(visitingSearch),prame)
    
    [SFBaseModel BPOST:BASE_URL(visitingSearch) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFVisitListModel class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:统计拜访信息
 * author:SkyWork
 */
+(void)clientVisitingCount:(NSDictionary *)prame
                   success:(void (^)(SFStatisticsModel * model))success
                   failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(visitingCount) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFStatisticsModel * smodel = [SFStatisticsModel modelWithJSON:model.result];
        !success?:success(smodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:通过客户id查询客户联系人
 * author:SkyWork
 */
+(void)getClientsContacts:(NSString *)cid
                  success:(void (^)(NSArray <ContactsModel *>* list))success
                  failure:(void (^)(NSError * error))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(orgGetLinkman),cid];
  
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        NSArray * array = [NSArray modelArrayWithClass:[ContactsModel class] json:model.result];
        !success?:success(array);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:拜访打卡
 * author:SkyWork
 */
+(void)updateVisitings:(NSDictionary *)pram
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(visitingUpdate) parameters:pram success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:完成拜访
 * author:SkyWork
 */
+(void)completeVisits:(NSDictionary *)pram
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BPUT:BASE_URL(completeVisit) parameters:pram success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}


/**
 * des:删除拜访
 * author:SkyWork
 */
+(void)deleteVisiting:(NSString *)URLString
              success:(void (^)(void))success
              failure:(void (^)(NSError *))failure {
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_URL(deletevisiting),URLString];
    [SFBaseModel DELETE:URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation EmployeeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation SFVisitListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"visitorList" : [EmployeeModel class]};
}


+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation ContactsModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
