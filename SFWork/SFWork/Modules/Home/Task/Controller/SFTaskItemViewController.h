//
//  SFTaskItemViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTaskHttpModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFTaskItemViewController : UIViewController

@property (nonatomic, strong) NSArray<TaskListModel *> *array;;
@property (nonatomic, assign) BOOL isBranch;
@property (nonatomic, copy) NSString *titles;

@end

NS_ASSUME_NONNULL_END
