//
//  SFCustomerHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFClientModel;
@interface SFCustomerHttpModel : NSObject

/**
 * des:新增客户
 * author:SkyWork
 */
+(void)addCompanyClient:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:获取部门客户/商家
 * author:SkyWork
 */
+(void)getDepCompanyClient:(NSDictionary *)prame
                   success:(void (^)(NSArray <SFClientModel *> *list))success
                   failure:(void (^)(NSError *))failure;

/**
 * des:获取个人客户/商家
 * author:SkyWork
 */
+(void)getMyCompanyClient:(NSDictionary *)prame
                   success:(void (^)(NSArray <SFClientModel *> *list))success
                   failure:(void (^)(NSError *))failure;

/**
 * des:获取下属私有客户/商家
 * author:SkyWork
 */
+(void)getPrivateClient:(NSDictionary *)prame
                success:(void (^)(NSArray <SFClientModel *> *list))success
                failure:(void (^)(NSError *))failure;

/**
 * des:通过id查询客户
 * author:SkyWork
 */
+(void)getClients:(NSString *)cid
          success:(void (^)(SFClientModel * model))success
          failure:(void (^)(NSError * error))failure;

/**
 * des:删除客户信息
 * author:SkyWork
 */
+(void)deleteClient:(NSString *)URLString
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure;

/**
 * des:修改客户信息
 * author:SkyWork
 */
+(void)updateClients:(NSDictionary *)pram
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure;

/**
 * des:搜索商家或客户
 * author:SkyWork
 */
+(void)searchClients:(NSDictionary *)prame
             success:(void (^)(NSArray <SFClientModel *> *list))success
             failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
