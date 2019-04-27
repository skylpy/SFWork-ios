//
//  SFSelectDepViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SFOrgListModel;

typedef NS_ENUM(NSInteger, SelectDepType){
    //以下是枚举成员
    singleDepType = 0,//单选
    multipleDepType = 1//多选
    
};

@protocol SFSelectDepViewControllerDelagete <NSObject>

@optional //可选
//单选
- (void)singleSelectEmoloyee:(SFOrgListModel *)employee;
//多选
- (void)multipleSelectEmoloyee:(NSArray <SFOrgListModel *> *)employees;

@end
@interface SFSelectDepViewController : UIViewController

@property (nonatomic, assign) SelectDepType type;
@property (nonatomic, weak) id <SFSelectDepViewControllerDelagete> delagete;

@property (nonatomic, assign) BOOL isJust;

@end

NS_ASSUME_NONNULL_END
