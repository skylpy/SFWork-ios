//
//  SFSetTypeModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSetTypeModel : NSObject

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;


/**
 * des:删除企业设置选项
 * author:SkyWork
 */
+(void)deleteCompanySetting:(NSString *)oid
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure;

/**
 * des:修改企业设置选项
 * author:SkyWork
 */
+(void)updateCompanySetting:(NSDictionary *)parm
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure;

/**
 * des:根据类型获取企业设置信息
 * author:SkyWork
 */
+(void)getCompanySetting:(NSString *)type
                 success:(void (^)(NSArray <SFSetTypeModel *> * list))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:新增企业设置选项
 * author:SkyWork
 */
+(void)addCompanySetting:(NSDictionary *)parm
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
