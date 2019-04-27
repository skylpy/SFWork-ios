//
//  SFLimitPunchViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SFAttendanceSetModel;
@interface SFLimitPunchViewController : SFBaseViewController

@property (nonatomic, copy) void (^selectModelClick)(SFAttendanceSetModel *model);

@end

NS_ASSUME_NONNULL_END
