//
//  SFExpenseListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFExpenseHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFExpenseListCell : UITableViewCell

@property (nonatomic, strong) ExpenseListModel *model;

@end

NS_ASSUME_NONNULL_END
