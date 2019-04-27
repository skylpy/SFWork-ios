//
//  SFLeaveApplicationViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class SFMyAttendanceModel;
@interface SFLeaveApplicationViewController : SFBaseViewController

@end

@interface SFAttenApplicationCell :SFBaseTableCell

@property (nonatomic, strong) SFMyAttendanceModel *model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);;

@end

@interface SFApplicationCell :SFBaseTableCell

@property (nonatomic, strong) SFMyAttendanceModel *model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);;

@end

NS_ASSUME_NONNULL_END
