//
//  SFOrganizationModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFEmployeesModel,SFOrgListModel;

@interface SFOrganizationModel : NSObject

/**
 * des:修改员工角色
 * author:SkyWork
 */
+(void)updateEmployeeRole:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:新增员工
 * author:SkyWork
 */
+(void)addCompanyEmployee:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:修改员工
 * author:SkyWork
 */
+(void)updateCompanyEmployee:(NSDictionary *)prame
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *))failure;

/**
 * des:新增部门
 * author:SkyWork
 */
+(void)addCompanyDep:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(NSError *))failure;

/**
 * des:修改部门
 * author:SkyWork
 */
+(void)updateCompanyDep:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure;

/**
 * des:获取组织架构
 * author:SkyWork
 */
+(void)getOrganizationList:(NSDictionary *)parm
                   success:(void (^)(SFOrgListModel * model))success
                   failure:(void (^)(NSError *))failure;

/**
 * des:获取组织架构(全部)
 * author:SkyWork
 */
+(void)getOrganizationAllList:(NSDictionary *)parm
                      success:(void (^)(SFOrgListModel * model))success
                      failure:(void (^)(NSError *))failure;

/**
 * des:直属上司接口
 * author:SkyWork
 */
+(void)getDirectlyAdminsSuccess:(void (^)(NSArray <SFEmployeesModel *>*list))success
                        failure:(void (^)(NSError *))failure;
/**
 * des:直属下属接口
 * author:SkyWork
 */
+(void)getDirectlyEmployeesSuccess:(void (^)(NSArray <SFEmployeesModel *>*list))success
                           failure:(void (^)(NSError *))failure;

/**
 * des:获取子部门
 * author:SkyWork
 */
+(void)orgGetChildrenList:(NSString *)oid
                  success:(void (^)(NSArray <SFOrgListModel * >*list))success
                  failure:(void (^)(NSError *))failure;


/**
 * des:获取所有员工
 * author:SkyWork
 */

+(void)getAllEmployeeListSuccess:(void (^)(NSArray <SFEmployeesModel * >*list))success
                         failure:(void (^)(NSError *))failure;

/**
 * des: 获取所有管理者
 * author:SkyWork
 */

+(void)getAllManagerListSuccess:(void (^)(NSArray <SFEmployeesModel * >*list))success
                        failure:(void (^)(NSError *))failure;

/**
 * des: 删除部门
 * author:SkyWork
 */
+(void)deleteDepartments:(NSString *)dep_id
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:批量删除员工
 * author:SkyWork
 */
+(void)deleteOrgEmployee:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:批量y移动员工
 * author:SkyWork
 */
+(void)moveOrgEmployee:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

@end

@interface SFOrgListModel : NSObject

@property (nonatomic, copy) NSString *_id;
//名称
@property (nonatomic, copy) NSString *name;
//上级ID
@property (nonatomic, copy) NSString *parentId;
//根部门
@property (nonatomic, assign) BOOL root;
//公司ID
@property (nonatomic, copy) NSString *companyId;
//创建时间
@property (nonatomic, copy) NSString *createTime;
//子部门
@property (nonatomic, copy) NSArray <SFOrgListModel *> *children;
//部门员工
@property (nonatomic, copy) NSArray <SFEmployeesModel *> *employees;

@property (nonatomic, copy) NSArray <SFEmployeesModel *> *admins;

@property (nonatomic, assign) BOOL isSelect;

@end

@interface SFEmployeesModel : NSObject

@property (nonatomic, copy) NSString *_id;
//员工名称
@property (nonatomic, copy) NSString *name;
//公司ID
@property (nonatomic, copy) NSString *companyId;
//部门ID
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;
//性别
@property (nonatomic, copy) NSString *gender;
//手机号码
@property (nonatomic, copy) NSString *phone;
//修改密码
@property (nonatomic, copy) NSString *plainPassword;
//邮件
@property (nonatomic, copy) NSString *email;
//状态
@property (nonatomic, copy) NSString *status;
//角色
@property (nonatomic, copy) NSString *role;
//头像
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *smallAvatar;
//工号
@property (nonatomic, copy) NSString *workNumber;
//创建时间
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, copy) NSString *positionId;

@property (nonatomic, assign) BOOL hiddenPhone;

/**
 * 猎鹰终端ID
 */
@property (nonatomic, copy) NSString *terminalId;
/**
 * 猎鹰服务ID
 */
@property (nonatomic, copy) NSString *sid;
//薪资
@property (nonatomic, copy) NSString *salary;

//是否选中
@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
