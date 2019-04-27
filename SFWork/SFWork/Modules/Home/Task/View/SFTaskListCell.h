//
//  SFTaskListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTaskHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFTaskListCell : UITableViewCell

@property (nonatomic, strong) TaskListModel *model;
@property (nonatomic, copy) void (^gestureClick)(TaskListModel *model);
@end

NS_ASSUME_NONNULL_END
