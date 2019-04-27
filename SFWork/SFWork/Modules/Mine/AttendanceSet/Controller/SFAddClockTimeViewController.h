//
//  SFAddClockTimeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AttendanceDateModel;
@interface SFAddClockTimeViewController : SFBaseViewController

@property (nonatomic, strong) AttendanceDateModel *models;
@property (nonatomic, copy) NSArray *selectDays;
@property (nonatomic, copy) void (^addTimeClick)(AttendanceDateModel * model);

@end

NS_ASSUME_NONNULL_END
