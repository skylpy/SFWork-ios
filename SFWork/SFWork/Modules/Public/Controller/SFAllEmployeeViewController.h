//
//  SFSelectEmployeeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SFEmployeesModel;

typedef NS_ENUM(NSInteger, SelectEmpType){
    //以下是枚举成员
    singleType = 0,//单选
    multipleType = 1//多选
    
};

@protocol SFAllEmployeeViewControllerDelagete <NSObject>

@optional //可选
//单选
- (void)singleSelectEmoloyee:(SFEmployeesModel *)employee;
//多选
- (void)multipleSelectEmoloyee:(NSArray <SFEmployeesModel *> *)employees;

@end

@interface SFAllEmployeeViewController : SFBaseViewController

@property (nonatomic, assign) SelectEmpType type;
@property (nonatomic, weak) id <SFAllEmployeeViewControllerDelagete> delagete;

@end

NS_ASSUME_NONNULL_END
