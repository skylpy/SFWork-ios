//
//  SFEmpSelectCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFEmpSelectCell : SFBaseTableCell

@property (nonatomic, strong) SFEmployeesModel *model;
@property (nonatomic, copy) void (^selectClick)(SFEmployeesModel *model);
@end

NS_ASSUME_NONNULL_END
