//
//  SFSelectSwitchBtnCell.h
//  SFWork
//
//  Created by fox on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSelectSwitchBtnCell : UITableViewCell
/** 设置置顶回调 */
@property (copy, nonatomic) void (^topBtnBlock)(BOOL isOpen);

@property (weak, nonatomic) IBOutlet UIImageView *arrowRight;
@property (weak, nonatomic) IBOutlet UIButton *swithBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *rightSubTitleLB;

@end

NS_ASSUME_NONNULL_END
