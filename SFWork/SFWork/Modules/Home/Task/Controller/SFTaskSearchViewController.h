//
//  SFTaskSearchViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class TaskListModel;
@interface SFTaskSearchViewController : SFBaseViewController

@property (nonatomic,copy) void (^taskSearchClick)(NSArray<TaskListModel *> * _Nonnull list);

@end

NS_ASSUME_NONNULL_END
