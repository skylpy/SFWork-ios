//
//  SFAddContactsViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SFAddContactsViewControllerDelegate <NSObject>

- (void)getContacts:(NSDictionary *)dic;

@end

@interface SFAddContactsViewController : SFBaseViewController

@property (nonatomic, weak) id <SFAddContactsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
