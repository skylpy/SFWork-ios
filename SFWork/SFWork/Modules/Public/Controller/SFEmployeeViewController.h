//
//  SFEmployeeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SFEmployeesModel;


@interface SFEmployeeViewController : SFBaseViewController

@property (nonatomic, copy) void (^selectAllClick)(NSArray *allArray);

@end

NS_ASSUME_NONNULL_END
