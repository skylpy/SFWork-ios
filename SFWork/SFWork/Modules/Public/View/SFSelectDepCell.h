//
//  SFSelectDepCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseTableCell.h"
#import "SFOrganizationModel.h"
#import "SFSelectDepViewController.h"
NS_ASSUME_NONNULL_BEGIN
@class SFOrgListModel;
@interface SFSelectDepCell : SFBaseTableCell

@property (nonatomic, strong) SFOrgListModel *model;
@property (nonatomic, assign) SelectDepType type;

@property (nonatomic, copy) void (^nextClick)(SFOrgListModel *model);

@property (nonatomic, copy) void (^selectClick)(SFOrgListModel *model);

@end

NS_ASSUME_NONNULL_END
