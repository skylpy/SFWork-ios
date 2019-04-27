//
//  SFOrganizationViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

@class SFOrgListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SFOrganizationViewController : SFBaseViewController

@property (nonatomic, copy) NSString *departmentId;

@property (nonatomic, copy) NSString *departName;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) SFOrgListModel *parentModel;

@property (nonatomic,copy) void (^didDeleteClick)(void);

@end

@interface SFOrganizationCell : UITableViewCell

@property (nonatomic, strong) SFOrgListModel *model;

@end

NS_ASSUME_NONNULL_END
