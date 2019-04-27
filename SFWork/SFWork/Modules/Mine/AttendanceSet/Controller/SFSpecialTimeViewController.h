//
//  SFSpecialTimeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class SpecialDateModel;
@interface SFSpecialTimeViewController : SFBaseViewController

@property (nonatomic, copy) void (^addTimeClick)(SpecialDateModel * model);

@end

NS_ASSUME_NONNULL_END
