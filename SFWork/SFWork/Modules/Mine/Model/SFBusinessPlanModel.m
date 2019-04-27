//
//  SFBusinessPlanModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBusinessPlanModel.h"

@implementation SFBusinessPlanModel

/**
 * des:获取企业套餐
 * author:SkyWork
 */
+(void)getCompanyInfoBusinessPlanSuccess:(void (^)(SFBusinessPlanModel * model))success
                                 failure:(void (^)(NSError *))failure {
    
    [SFBaseModel BGET:BASE_URL(getCompanyInfo) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFBusinessPlanModel * amodel = [SFBusinessPlanModel modelWithJSON:model.result];;
        !success?:success(amodel);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"companyLifeList" : [CompanyLifeModel class]
             };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"_id" : @"id"
             };
}

@end

@implementation CompanyLifeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"_id" : @"id"
             };
}

@end
