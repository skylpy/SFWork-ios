//
//  SFAddJournalViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SFJournalModel;
@interface SFAddJournalViewController : SFBaseViewController

@end

@interface SFAddJournalCell : SFBaseTableCell

@property (nonatomic, strong) SFJournalModel *model;

@end

NS_ASSUME_NONNULL_END
