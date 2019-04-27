//
//  SFDepListViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFDepListViewController : SFBaseViewController

@property (nonatomic, copy) NSString *atype;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isAtten;

@end

NS_ASSUME_NONNULL_END
