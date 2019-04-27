//
//  SFSwitchCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCustomerModel.h"
#import "SFJournalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSwitchCell : UITableViewCell

@property (nonatomic, strong) SFCustomerModel * model;
@property (nonatomic, strong) SFJournalModel *jmodel;

@property (nonatomic, copy) void (^selectClick)(BOOL isOn);

@end

NS_ASSUME_NONNULL_END
