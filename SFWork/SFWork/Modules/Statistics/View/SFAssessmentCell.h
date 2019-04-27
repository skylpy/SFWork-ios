//
//  SFAssessmentCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAssessmentCell : SFBaseTableCell

@property (nonatomic, strong) RatingSettingModel *model;
@property (nonatomic, assign) NSInteger value;
- (void)cellWithValue:(NSInteger )value withModel:(RatingSettingModel *)model;

@end

NS_ASSUME_NONNULL_END
