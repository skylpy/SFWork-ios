//
//  SFDevTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN
@class SFOrgListModel;

@interface SFDevTableCell : UITableViewCell

@property (nonatomic, strong) SFOrgListModel *model;

@property (nonatomic, copy) void (^nextClick)(SFOrgListModel *model);

@end

NS_ASSUME_NONNULL_END
