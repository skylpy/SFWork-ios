//
//  SFSystemMessageModel.m
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSystemMessageModel.h"

@implementation SFSystemMessageModel
/**
 * des:消息列表
 */
+(void)getSystemMessageList:(NSDictionary *)prame
                       success:(void (^)(NSArray <SystemMessageModel *>*list))success
                       failure:(void (^)(NSError *))failure {
    
    
    [SFBaseModel BGET:BASE_URL(systemMessage) parameters:prame success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        NSArray * array = [NSArray modelArrayWithClass:[SystemMessageModel class] json:model.result[@"list"]];
        !success?:success(array);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:根据ID找头像和名称
 */
+(void)getNameAndAvatarList:(NSString *)u_id
                    success:(void (^)(UserInfoModel *mode))success
                    failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(getNameAndAvatar),u_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        UserInfoModel * mod = [UserInfoModel modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

/**
 * des:根据ID找头像和名称
 */
+(void)getGroudNameAndAvatarList:(NSString *)u_id
                         success:(void (^)(UserInfoModel *mode))success
                         failure:(void (^)(NSError *))failure {
    
    NSString * URLString = [NSString stringWithFormat:@"%@%@",BASE_URL(chatGroupInfo),u_id];
    [SFBaseModel BGET:URLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        UserInfoModel * mod = [UserInfoModel modelWithJSON:model.result];
        !success?:success(mod);
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        !failure?:failure(error);
    }];
}

@end

@implementation SystemMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID" : @"id"};
}

@end

@implementation UserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
