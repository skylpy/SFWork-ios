//
//  SFAttendanceRulesViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"
NS_ASSUME_NONNULL_BEGIN
@class SFAttendanceSetModel,SFAttendanceModel;
@interface SFAttendanceRulesViewController : SFBaseViewController

@property (nonatomic, strong) SFAttendanceModel * smodel;
@property (nonatomic, copy) void (^reduceClick)(void);;

@end

@interface SFAttendanceRulesCell : SFBaseTableCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) SFAttendanceSetModel *model;

@end

NS_ASSUME_NONNULL_END
