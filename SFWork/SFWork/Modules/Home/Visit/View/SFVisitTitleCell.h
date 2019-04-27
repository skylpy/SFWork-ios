//
//  SFVisitTitleCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFStatisticsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFVisitTitleCell : UITableViewCell

@property (nonatomic, strong) StatisticsList *model;
@property (nonatomic, strong) StatisticsList *smodel;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
