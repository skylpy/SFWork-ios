//
//  SFMailHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/23.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ContactsList;
@interface SFMailHttpModel : NSObject

/**
 * des:获取联系人
 * author:SkyWork
 */
+(void)getMailEmployeeContacts:(NSDictionary *)prame
                       success:(void (^)(NSArray <ContactsList *>*list))success
                       failure:(void (^)(NSError *))failure;

@end

@interface ContactsList : NSObject

@property (nonatomic, copy) NSString *departmentName;
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

@end

NS_ASSUME_NONNULL_END
