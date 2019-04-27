//
//  SFMailListTableCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFMailHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFMailListTableCell : UITableViewCell

@property (nonatomic, strong) ContactsList *model;

@property (nonatomic, copy) void (^tellPhoneClick)(NSString * phone);
@property (nonatomic, copy) void (^chatClcik)(ContactsList *model);

@end

NS_ASSUME_NONNULL_END
