//
//  SFAssessmentListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFWorkAssessHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentListCell : SFBaseTableCell

@property (nonatomic, strong) SFWorkCheckItemModel *model;

@end

NS_ASSUME_NONNULL_END
