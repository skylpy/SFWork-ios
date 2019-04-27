//
//  SFAnnounceHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAnnounceHttpModel.h"

@implementation SFAnnounceHttpModel

/**
 * des: 获取公告列表
 * author:SkyWork
 */
+(void)getAnnounceList:(NSDictionary *)prame
               success:(void (^)(NSArray <SFAnnounceListModel *>* list))success
               failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(getInformationLists) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SFAnnounceListModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:保存发布修改
 * author:SkyWork
 */
+(void)submitInformation:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BPOST:BASE_URL(saveInformation) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:  获取详情
 * author:SkyWork
 */
+(void)getApprovalDetails:(NSString *)a_id
                  success:(void (^)(SFAnnounceListModel * model))success
                  failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(informationDetail),a_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        AppLocal(10)
        SFAnnounceListModel * mode = [SFAnnounceListModel modelWithJSON:model.result];;
        !success?:success(mode);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:删除拜访
 * author:SkyWork
 */
+(void)deleteInformation:(NSString *)URLString
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure {
    
    NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_URL(delInformation),URLString];
    [SFBaseModel DELETE:URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        !success?:success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation SFAnnounceListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"informationUserList" : [InformationUserModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end

@implementation InformationUserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
