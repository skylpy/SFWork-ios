//
//  SFCBDateilViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFCustomerModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFCBDateilViewController : SFBaseViewController

@property (nonatomic, assign) CustomerType type;
@property (nonatomic, strong) SFClientModel * model;

@end

NS_ASSUME_NONNULL_END
