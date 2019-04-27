//
//  SFAddExpenseViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"
NS_ASSUME_NONNULL_BEGIN
@class SFExpenseModel;
@interface SFAddExpenseViewController : SFBaseViewController

@end

@interface SFExpenseTitleCell : SFBaseTableCell

@property (nonatomic,strong) SFExpenseModel * model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);;

@end

NS_ASSUME_NONNULL_END
