//
//  SFAllContactListViewController.h
//  SFWork
//
//  Created by fox on 2019/3/31.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFAllContactListViewController : UIViewController
/*
 *是否是从群管理进来
 */
@property (nonatomic) BOOL isGroupManager;
/*
 *禁言全部
 */
@property (nonatomic,copy) NSString * isBan;
/*
 *是否展示禁言白名单
 */
@property (nonatomic) BOOL isShowNoBan;
/*
 *是否展示禁言名单
 */
@property (nonatomic) BOOL isShowBan;
/*
 *是否添加群成员
 */
@property (nonatomic) BOOL isAddGroupMember;
/*
 *选中的人员
 */
@property (copy, nonatomic) void (^selectSureBlock)(NSArray * selectList);

@property (nonatomic, copy) NSString * currChatId;
@property (nonatomic, copy) NSString * currChatName;
@end

NS_ASSUME_NONNULL_END
