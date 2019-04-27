//
//  SFGroupSwithBtnWithTipCell.h
//  ClassForEvery
//
//  Created by Adam on 2019/4/2.
//  Copyright © 2019年 Adam. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFGroupSwithBtnWithTipCell : UITableViewCell
/**
 
 * isOn 是否打开开光
 
 */
@property (copy, nonatomic) void (^swithBlock)(BOOL isOn);
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;

@end

NS_ASSUME_NONNULL_END
