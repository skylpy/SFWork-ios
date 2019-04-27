//
//  SFSelCustomerViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class SFClientModel;
@interface SFSelCustomerViewController : SFBaseViewController

@property (nonatomic, copy) void (^selCustomerClick)(SFClientModel * cmodel);

@end

NS_ASSUME_NONNULL_END
