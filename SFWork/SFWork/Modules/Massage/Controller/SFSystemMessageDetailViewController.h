//
//  SFSystemMessageDetailViewController.h
//  SFWork
//
//  Created by fox on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SystemMessageDetailCell;
@interface SFSystemMessageDetailViewController : UIViewController
@property (copy, nonatomic) void (^readBlock)(void);
@property (copy, nonatomic) NSString * messageId;

@end

@interface SystemMessageDetailCell : UITableViewCell
@property (strong, nonatomic) UILabel * titleLB;
@property (strong, nonatomic) UILabel * timeLB;
@property (strong, nonatomic) UILabel * contentLb;
/**
 *设置内容
 */
- (void)setTitle:(NSString *)title Time:(NSString *)time Content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
