//
//  SFTaskCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTaskHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SFTaskCellDelegate <NSObject>

- (void)selectTaskItem:(TaskListModel *)model;

- (void)LongPressGestureTaskItem:(TaskListModel *)model;

@end
@interface SFTaskCell : UITableViewCell

@property (nonatomic, strong) NSArray<TaskListModel *> *array;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL isBranch;
@property (nonatomic, copy) void (^openTaskClick)(NSArray<TaskListModel *> *array);
@property (nonatomic, weak) id <SFTaskCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
