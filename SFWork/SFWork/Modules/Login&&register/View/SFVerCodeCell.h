//
//  SFVerCodeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFForGetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFVerCodeCell : UITableViewCell

@property (nonatomic, strong) SFForGetModel * model;

@property (nonatomic, copy) void (^getCodeClick)(UIButton * sender);

@end

NS_ASSUME_NONNULL_END
