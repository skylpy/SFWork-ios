//
//  SFAllManagerViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SFEmployeesModel;

typedef NS_ENUM(NSInteger, SelectManagerType){
    //以下是枚举成员
    singlemType = 0,//单选
    multiplemType = 1//多选
    
};

@protocol SFAllManagerViewControllerDelagete <NSObject>

@optional //可选
//单选
- (void)singleSelectAllManager:(SFEmployeesModel *)employee;
//多选
- (void)multipleSelectAllManager:(NSArray <SFEmployeesModel *> *)employees;

@end
@interface SFAllManagerViewController : SFBaseViewController


@property (nonatomic, assign) SelectManagerType type;
@property (nonatomic, weak) id <SFAllManagerViewControllerDelagete> delagete;
@property (nonatomic, copy) void (^selectAllClick)(NSArray *allArray);

@end

NS_ASSUME_NONNULL_END
