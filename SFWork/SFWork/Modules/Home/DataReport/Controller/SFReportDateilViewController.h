//
//  SFReportDateilViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SFTemplateModel;
@interface SFReportDateilViewController : SFBaseViewController

@property (nonatomic, strong) SFTemplateModel *model;
@property (nonatomic, copy) void (^backLastPage)();

@end

NS_ASSUME_NONNULL_END
