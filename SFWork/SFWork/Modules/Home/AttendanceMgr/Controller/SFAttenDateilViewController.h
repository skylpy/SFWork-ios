//
//  SFAttenDateilViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"
#import "SFAttendanceMgrModel.h"
#import "SFAttendanceMgrHttpModel.h"
#import "SFAttendanceMgrViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAttenDateilViewController : SFBaseViewController

@property (nonatomic, strong) BusinessTripLeaveOvertimeModel *model;
@property (nonatomic, assign) ApprovalListType type;
@property (nonatomic, assign) ApprovalType atype;

@end

@interface SFAttenTitleCell : SFBaseTableCell

@property (nonatomic, strong) SFAttendanceMgrModel *model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);;

@end

NS_ASSUME_NONNULL_END
