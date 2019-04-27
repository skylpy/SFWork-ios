//
//  SFRegisterViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFRegisterModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SFRegisterViewControllerDelegate <NSObject>

- (void)registerBackLogin;

@end
@interface SFRegisterViewController : SFBaseViewController

@property (nonatomic, weak) id <SFRegisterViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
