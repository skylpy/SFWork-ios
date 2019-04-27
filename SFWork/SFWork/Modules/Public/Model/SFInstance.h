//
//  SFInstance.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/5.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SFUserInfo,SFCompanyInfo,PermissionsModel;

@interface SFInstance : NSObject

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *employeeId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *validTime;
@property (nonatomic, copy) NSString *rongCloud;

//OSS bucketName
@property (nonatomic, copy) NSString *bucketName;
//OSS endpoint
@property (nonatomic, copy) NSString *endpoint;
//OSS expiration
@property (nonatomic, copy) NSString *expiration;

/** 登陆账户信息 */
@property (nonatomic, strong) SFUserInfo   * userInfo;
/** 公司信息 */
@property (nonatomic, strong) SFCompanyInfo    * companyInfo;

/** 获取唯一实例 */
+ (instancetype) shareInstance;
/** 注销账号 */
- (void)logout;

@end

@interface SFUserInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *positionName;
@property (nonatomic, copy) NSString *positionId;
@property (nonatomic, assign) BOOL hiddenPhone;
/**
 * des:创建时间
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *createTime;
/**
 * des:个人ID
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *_id;
/**
 * des:个人名称
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *name;
/**
 * des:公司id
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *companyId;
/**
 * des:部门ID
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;

/**
 * des:性别
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *gender;
/**
 * des:电话
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *phone;
/**
 * des:密码
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *plainPassword;
/**
 * des:邮件
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *email;
/**
 * des:账号状态
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *status;
/**
 * des:角色
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *role;
/**
 * des:头像
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *avatar;

/**
 * des:小头像
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *smallAvatar;

/**
 * des:工号
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *workNumber;

/**
 * des:融云
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *rongCloudId;

/**
 * des:权限
 * author:SkyWork
 */
@property (nonatomic, copy) NSArray <PermissionsModel*>*permissions;

@property (nonatomic, copy) NSArray *permissionIds;

/**
 * 猎鹰终端ID
 */
@property (nonatomic, copy) NSString *terminalId;
/**
 * 猎鹰服务ID
 */
@property (nonatomic, copy) NSString *sid;

@end

@interface SFCompanyInfo : NSObject<NSCoding>

/**
 * des:公司信息
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *account;
/**
 * des:创建时间
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *createTime;

/**
 * des:公司ID
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *_id;

/**
 * des:邀请码
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *invitationCode;

/**
 * des:公司名称
 * author:SkyWork
 */
@property (nonatomic, copy) NSString *name;

@end

//权限
@interface PermissionsModel : NSObject
//模块代码
@property (nonatomic, copy) NSString *code;
//时间
@property (nonatomic, copy) NSString *createTime;
//是否t有权限
@property (nonatomic, assign) BOOL hasPermission;
//ID
@property (nonatomic, copy) NSString *id;
//名字
@property (nonatomic, copy) NSString *name;
//在那个分组
@property (nonatomic, copy) NSString *permissionGroup;

@end

NS_ASSUME_NONNULL_END
