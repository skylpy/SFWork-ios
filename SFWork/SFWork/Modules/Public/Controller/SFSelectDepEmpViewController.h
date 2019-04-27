//
//  SFSelectDepEmpViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFAllEmployeeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSelectDepEmpViewController : SFBaseViewController

@property (nonatomic, assign) SelectEmpType type;
@property (nonatomic, strong) SFOrgListModel *orgModel;

@property (nonatomic, copy) void (^selectEmoClick)(SFEmployeesModel *model);

@end

NS_ASSUME_NONNULL_END
