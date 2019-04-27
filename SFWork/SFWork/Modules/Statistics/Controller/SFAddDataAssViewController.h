//
//  SFAddDataAssViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAddDataAssViewController : SFBaseViewController

@property (nonatomic, copy) void (^completeClick)(ItemsModel *item);
@property (nonatomic, copy) ItemsModel *model;

@end


NS_ASSUME_NONNULL_END
