//
//  SFAddPowerViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFPowerHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFAddPowerViewController : SFBaseViewController

@property (nonatomic, strong) SFPowerListModel * model;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
