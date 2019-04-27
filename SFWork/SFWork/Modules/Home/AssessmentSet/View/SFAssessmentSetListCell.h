//
//  SFAssessmentSetListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFWorkAssessHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentSetListCell : SFBaseTableCell

@property (nonatomic, strong) SFWorkAssessItemModel *model;

@property (nonatomic, strong) ItemSubListModel *smodel;

@end

NS_ASSUME_NONNULL_END
