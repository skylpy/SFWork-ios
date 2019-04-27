//
//  SFSalaryEntryViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFOrganizationViewController.h"

@class SFOrgListModel;
NS_ASSUME_NONNULL_BEGIN

@interface SFSalaryEntryViewController : SFBaseViewController

@property (nonatomic, copy) NSString *departmentId;

@property (nonatomic, copy) NSString *departName;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic, strong) SFOrgListModel *parentModel;

@end

NS_ASSUME_NONNULL_END
