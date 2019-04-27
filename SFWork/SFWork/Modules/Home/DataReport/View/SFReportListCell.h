//
//  SFReportListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFDataReportHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFReportListCell : SFBaseTableCell

@property (nonatomic, strong) SFTemplateModel * model;

@property (nonatomic, copy) void (^selectEmpClick)(SFTemplateModel * item);

@end

NS_ASSUME_NONNULL_END
