//
//  SFAllPowerCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFAttendanceSetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAllPowerCell : SFBaseTableCell

@property (nonatomic, copy) void (^selectAllClick)(BOOL isSelect);

@property (nonatomic, strong) SFAttendanceSetModel *model;
@end

NS_ASSUME_NONNULL_END
