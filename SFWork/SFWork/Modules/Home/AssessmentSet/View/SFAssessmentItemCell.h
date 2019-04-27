//
//  SFAssessmentItemCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFAssessmentSetModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentItemCell : SFBaseTableCell

@property (nonatomic, strong) SFAssessmentSetModel *model;
@property (nonatomic, copy) void (^deleteClick)(SFAssessmentSetModel * model);
@property (nonatomic, copy) void (^selectClick)(ItemSubListModel * model);

@end

NS_ASSUME_NONNULL_END
