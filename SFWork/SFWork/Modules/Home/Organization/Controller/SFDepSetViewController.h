//
//  SFDepSetViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFDepSetViewController : SFBaseViewController

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, strong) SFOrgListModel *model;
@property (nonatomic, copy) NSString *departName;
@property (nonatomic,copy) void (^didSaveClick)(void);
@property (nonatomic,copy) void (^didDeleteClick)(void);
@end

NS_ASSUME_NONNULL_END
