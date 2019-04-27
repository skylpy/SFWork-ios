//
//  SFAddVisitViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"
@class SFVisitModel;
NS_ASSUME_NONNULL_BEGIN

@interface SFAddVisitViewController : SFBaseViewController

@property (nonatomic, assign) BOOL isBusiness;
@property (nonatomic, copy) void (^addCompleteClick)(void);

@end

@interface SFAddVisitCell : SFBaseTableCell

@property (nonatomic,strong) SFVisitModel * model;

@end

NS_ASSUME_NONNULL_END
