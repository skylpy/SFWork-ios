//
//  SFProfileViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFProfileViewController : SFBaseViewController

//是否从组积架构进入
@property (nonatomic, assign) BOOL isOrg;

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *departmentId;
@property (nonatomic, copy) NSString *departmentName;

//员工资料
@property (nonatomic, strong) SFEmployeesModel *employees;

@property (nonatomic,copy) void (^didSaveClick)(void);

@end

NS_ASSUME_NONNULL_END
