//
//  SFPunchClockTimeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAttendanceSetHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFPunchClockTimeCell : UITableViewCell

@property (nonatomic, strong) AttendanceDateModel *model;
@property (nonatomic, strong) SpecialDateModel *smodel;
@property (nonatomic, strong) SFAddressModel *amodel;

@end

NS_ASSUME_NONNULL_END
