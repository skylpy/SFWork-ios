//
//  SFGroupInfoModel.h
//  SFWork
//
//  Created by fox on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGroupInfoModel : NSObject
/**
 * 群ID
 */
@property (nonatomic, copy) NSString *ID;
/**
 * 群名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 群主ID
 */
@property (nonatomic, copy) NSString *masterId;
/**
 * 仅管理员可管理
 */
@property (nonatomic, copy) NSString *onlyMasterManage;
/**
 * 群聊邀请确认,
 */
@property (nonatomic, copy) NSString *invitationConfirm;
/**
 * 禁言全部
 */
@property (nonatomic, copy) NSString *isBan;
/**
 * 创建时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 * 群成员
 */
@property (nonatomic, copy) NSMutableArray * members;

@end

NS_ASSUME_NONNULL_END
