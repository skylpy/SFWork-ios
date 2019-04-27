//
//  SFSalarySetViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSalarySetViewController : SFBaseViewController

@property (nonatomic, copy) NSString *empId;
@property (nonatomic, copy) NSString *empName;
@property (nonatomic, copy) NSString *salary;

@property (nonatomic,copy) void (^didSaveClick)(void);

@end

NS_ASSUME_NONNULL_END
