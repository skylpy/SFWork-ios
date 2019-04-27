//
//  SFSystemMessageModel.h
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SystemMessageModel,UserInfoModel;
@interface SFSystemMessageModel : NSObject
/**
 * des:系统消息列表
 */
+(void)getSystemMessageList:(NSDictionary *)prame
                       success:(void (^)(NSArray <SystemMessageModel *>*list))success
                       failure:(void (^)(NSError *))failure;
/**
 * des:根据ID找头像和名称
 */
+(void)getNameAndAvatarList:(NSString *)u_id
                    success:(void (^)(UserInfoModel *mode))success
                    failure:(void (^)(NSError *))failure ;

/**
 * des:根据ID找头像和名称
 */
+(void)getGroudNameAndAvatarList:(NSString *)u_id
                         success:(void (^)(UserInfoModel *mode))success
                         failure:(void (^)(NSError *))failure ;
@end

@interface SystemMessageModel:NSObject
/**
 * "title": "标题"
 */
@property (nonatomic, copy) NSString *title;
/**
 * content": "内容",
 */
@property (nonatomic, copy) NSString *content;
/**
 *  "employeeId": "用户ID",
 */
@property (nonatomic, copy) NSString *employeeId;
/**
 * "消息事件",后期通过不同的事件跳转到不同页面
 */
@property (nonatomic, copy) NSString *event;
/**
 * id
 */
@property (nonatomic, copy) NSString *ID;
/**
 * 创建时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 * READ",READ=已读，UNREAD=未读
 */
@property (nonatomic, copy) NSString *status;
/**
 *
 */
@property (nonatomic, copy) NSString *extras;

/**
 *消息数
 */
@property (nonatomic, copy) NSString *count;
@end

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *_id;

@end

NS_ASSUME_NONNULL_END
