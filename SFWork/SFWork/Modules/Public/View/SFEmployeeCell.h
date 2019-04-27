//
//  SFEmployeeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFOrganizationModel.h"
#import "SFAllEmployeeViewController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SFEmployeeCellDelegate <NSObject>

- (void)selectEmployee:(SFEmployeesModel *)model;

@end

@interface SFEmployeeCell : UITableViewCell

@property (nonatomic, strong) SFEmployeesModel *model;
@property (nonatomic, assign) SelectEmpType type;

@property (nonatomic, weak) id <SFEmployeeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
