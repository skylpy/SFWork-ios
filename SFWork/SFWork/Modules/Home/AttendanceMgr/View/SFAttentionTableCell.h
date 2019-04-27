//
//  SFAttentionTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFAttendanceMgrHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAttentionTableCell : SFBaseTableCell

@property (nonatomic, strong) BusinessTripLeaveOvertimeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;

@end

NS_ASSUME_NONNULL_END
