//
//  SFSuperSuborViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAllEmployeeViewController.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SFSuperSuborViewControllerDelagete <NSObject>

@optional //可选
//单选
- (void)singlesSelectEmoloyee:(SFEmployeesModel *)employee;
//多选
- (void)multiplesSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees;

@end
@interface SFSuperSuborViewController : UIViewController
//是否下属
@property (nonatomic, assign) BOOL isSubor;
@property (nonatomic, assign) SelectEmpType type;
@property (nonatomic, weak) id <SFSuperSuborViewControllerDelagete> delagete;

@end

NS_ASSUME_NONNULL_END
