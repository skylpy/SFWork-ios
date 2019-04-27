//
//  SFRegisterModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFForGetModel.h"
NS_ASSUME_NONNULL_BEGIN

@class BaseModel;
@interface SFRegisterModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isClick;

+ (NSArray *)shareRegisterModel;

+ (NSMutableDictionary *)pramJson:(NSArray *)data;

@end

@interface SFRegHttpModel : NSObject

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *validTime;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *rongCloud;

/**
 * des:获取城市j数据GET /common/getCityData
 * author:SkyWork
 */
+(void)getCityDataSuccess:(void (^)(NSArray<AddressModel *>*address))success
                  failure:(void (^)(NSError *))failure;
/**
 * des:企业注册
 * author:SkyWork
 */
+(void)registerCompany:(NSDictionary *)prame
               success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:登录
 * author:SkyWork
 */
+(void)loginWithUser:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(BaseModel *model))failure;

/**
 * des:重置密码
 * author:SkyWork
 */
+(void)resetPwdWithUser:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:重置密码发送验证码
 * author:SkyWork
 */
+(void)resetPwdSendVercodes:(NSDictionary *)prame
                    success:(void (^)(NSArray <ForGetModel *> *list))success
                    failure:(void (^)(NSError *))failure;

/**
 * des:获取当前公司信息
 * author:SkyWork
 */
+(void)getCompanyInfoSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:获取当前员工资料
 * author:SkyWork
 */
+(void)getSelfInfoSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:获取OSS 的token
 * author:SkyWork
 */
+(void)getSelfInfoSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
