//
//  SFMailHttpModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMailHttpModel.h"

@implementation SFMailHttpModel

/**
 * des:获取联系人
 * author:SkyWork
 */
+(void)getMailEmployeeContacts:(NSDictionary *)prame
                       success:(void (^)(NSArray <ContactsList *>*list))success
                       failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BPOST:BASE_URL(employeeContacts) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[ContactsList class] json:model.result];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation ContactsList

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
