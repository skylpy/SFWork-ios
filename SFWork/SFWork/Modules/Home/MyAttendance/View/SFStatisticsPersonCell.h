//
//  SFStatisticsPersonCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMyAttendanceHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFStatisticsPersonCell : UITableViewCell

@property (nonatomic, strong) AttendanceStatisticsModel * model;

@end

NS_ASSUME_NONNULL_END
