//
//  SFContactCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFCustomerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFContactCell : UITableViewCell


@property (nonatomic, copy) void (^deleteClick)(ClientLinkModel *cmodel);
@property (nonatomic, strong) ClientLinkModel *model;
@property (nonatomic, assign) BOOL isHiden;
@end

NS_ASSUME_NONNULL_END
