//
//  SFPunchCardRecordCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFMyAttendanceHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFPunchCardRecordCell : UITableViewCell

@property (nonatomic, strong) MyAttendanceGetRecord *model;

@property (weak, nonatomic) IBOutlet UIView *upLineView;
@property (weak, nonatomic) IBOutlet UIView *downLineView;

@end

NS_ASSUME_NONNULL_END
