//
//  SFAttendanceListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAttendanceSetHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAttendanceListCell : UITableViewCell

@property (nonatomic, strong) SFAttendanceModel * model;

@end

NS_ASSUME_NONNULL_END
