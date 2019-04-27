//
//  SFJournalSetCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFJournalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFJournalSetCell : SFBaseTableCell

@property (nonatomic, strong) SFJournalModel *model;

@end

NS_ASSUME_NONNULL_END
