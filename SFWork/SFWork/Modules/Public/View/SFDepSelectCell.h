//
//  SFDepSelectCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SFOrgListModel;
@interface SFDepSelectCell : SFBaseTableCell
@property (nonatomic, strong) SFOrgListModel *model;

@property (nonatomic, copy) void (^nextClick)(SFOrgListModel *model);
@property (nonatomic, copy) void (^selectClick)(SFOrgListModel *model);


@end

NS_ASSUME_NONNULL_END
