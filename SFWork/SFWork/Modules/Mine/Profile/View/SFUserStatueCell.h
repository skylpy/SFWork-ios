//
//  SFUserStatueCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFProfileModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFUserStatueCell : UITableViewCell
@property (nonatomic, copy) void (^selectAllClick)(BOOL isSelect);
@property (nonatomic, strong) SFProfileModel * model;
@end

NS_ASSUME_NONNULL_END
