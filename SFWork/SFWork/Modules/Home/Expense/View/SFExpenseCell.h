//
//  SFExpenseCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFExpenseModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SFExpenseCellDelegate <NSObject>

@optional

- (void)cellSelectModel:(SFApprpvalModel *)model;

@end

@interface SFExpenseCell : SFBaseTableCell

@property (nonatomic, strong) SFExpenseModel *model;

@property (nonatomic, assign) id <SFExpenseCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
