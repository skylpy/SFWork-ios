//
//  SFAddTaskViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN
@class SFTaskModel;
@interface SFAddTaskViewController : SFBaseViewController

@property (nonatomic, assign) BOOL isSelf;

@end

@interface SFAddTaskCell : SFBaseTableCell

@property (nonatomic,strong) SFTaskModel * model;


@end

NS_ASSUME_NONNULL_END
