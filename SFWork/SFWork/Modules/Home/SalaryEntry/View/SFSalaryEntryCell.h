//
//  SFSalaryEntryCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFSalaryEntryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFSalaryEntryCell : UITableViewCell

@property (nonatomic, strong) SFSalaryEntryModel *model;
@property (nonatomic, copy) void (^selectClick)(SFSalaryEntryModel * mod);

@end

NS_ASSUME_NONNULL_END
