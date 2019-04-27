//
//  SFGroupMemberModel.h
//  SFWork
//
//  Created by fox on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGroupMemberModel : NSObject
/**
 * 成员ID
 */
@property (nonatomic, copy) NSString * employeeId;
/**
 * 名称
 */
@property (nonatomic, copy) NSString * name;
/**
 * 是否置顶
 */
@property (nonatomic, copy) NSString * isStick;
/**
 * 是否免打扰
 */
@property (nonatomic, copy) NSString * isNoDisturbing;
/**
 * 是否禁言
 */
@property (nonatomic, copy) NSString *isBan;
/**
 * 是否是白名单
 */
@property (nonatomic, copy) NSString *isIgnoreBanAll;
/**
 * 头像
 */
@property (nonatomic, copy) NSString *avatar;
/**
 * 头像缩略图
 */
@property (nonatomic, copy) NSString *smallAvatar;
@end

NS_ASSUME_NONNULL_END
