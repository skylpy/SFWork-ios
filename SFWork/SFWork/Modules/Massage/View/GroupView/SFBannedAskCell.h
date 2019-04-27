//
//  SFBannedAskCell.h
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBannedAskCell : UITableViewCell
@property (strong, nonatomic) UIViewController * rootVC;
@property (copy, nonatomic) NSString * groupId;

@property (weak, nonatomic) IBOutlet UILabel *tipLB;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
/**
 * 展示所有被禁言的成员
 */
- (void)showAllBanMemberList:(NSString *)groupId;

/**
 * 展示所有没有禁言的成员
 */
- (void)showALlNobanMemberList:(NSString *)groupId;
/**
 * (禁言全部)  YES 为展示禁言白名单  NO 为展示禁言名单
 */
@property (nonatomic,copy) NSString * isBan;
@end

NS_ASSUME_NONNULL_END
