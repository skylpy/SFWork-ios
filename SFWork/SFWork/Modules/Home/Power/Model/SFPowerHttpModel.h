//
//  SFPowerHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFPowerListModel,EmpPermissionModel;
@interface SFPowerHttpModel : NSObject

/**
 * des:获取权限列表
 * author:SkyWork
 */
+(void)getMyPowerListsType:(NSString *)type
                   success:(void (^)(NSArray <SFPowerListModel *>*list))success
                   failure:(void (^)(NSError *))failure;

/**
 * des: 获取授权信息详情
 * author:SkyWork
 */
+(void)getPermissionListsPid:(NSString *)pid
                     success:(void (^)(EmpPermissionModel * model))success
                     failure:(void (^)(NSError *))failure ;

/**
 * des:对用户进行授权
 * author:SkyWork
 */
+(void)addPermissioneUser:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:获取根据类型获取默认权限设置
 * author:SkyWork
 */
+(void)getDefaultPermission:(NSString *)type
                    success:(void (^)(NSArray <PermissionsModel *>*list))success
                    failure:(void (^)(NSError *))failure;
/**
 * des:删除授权
 * author:SkyWork
 */
+(void)deletePermissioneUser:(NSString *)pid
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure ;
@end

@interface SFPowerListModel : NSObject

@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSArray *permissionIds;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *typeName;

@end

@interface EmpPermissionModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *employeeName;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSArray *permissionIds;
@property (nonatomic, copy) NSArray <PermissionsModel*>*permissions;

@end

NS_ASSUME_NONNULL_END
