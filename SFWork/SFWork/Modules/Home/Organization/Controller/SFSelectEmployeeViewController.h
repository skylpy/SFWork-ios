//
//  SFSelectEmployeeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFOrganizationModel.h"
#import "SFBaseTableCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFSelectEmployeeViewController : SFBaseViewController

@property (nonatomic, strong) SFOrgListModel *model;
@property (nonatomic, assign) NSInteger type; //0 批量删除   1 批量移动  2 选择管理员

@property (nonatomic,copy) void (^didSaveClick)(void);

@end

@protocol SFSelectEmpCellDelegate <NSObject>

- (void)selectEmpNumber;

@end

@interface SFSelectEmpCell : SFBaseTableCell

@property (nonatomic, strong) SFEmployeesModel *model;
@property (nonatomic, weak ) id <SFSelectEmpCellDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
