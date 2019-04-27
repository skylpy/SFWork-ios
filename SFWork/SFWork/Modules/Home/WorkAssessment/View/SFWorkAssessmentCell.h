//
//  SFWorkAssessmentCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFWorkAssessPersonModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFWorkAssessmentCell : SFBaseTableCell

@property (nonatomic, strong) SocreDetailModel *model;
@property (nonatomic, copy) void (^selectSocreClick)(ScoreListModel * model);

@end

NS_ASSUME_NONNULL_END
