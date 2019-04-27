//
//  SFApprovalProCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFExpenseModel.h"
#import "SFAttendanceMgrModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFApprovalProCell : SFBaseTableCell

@property (nonatomic, strong) SFExpenseModel *model;
@property (nonatomic, copy) NSArray *array;

@property (nonatomic, strong) SFAttendanceMgrModel *attModel;

@end

NS_ASSUME_NONNULL_END
