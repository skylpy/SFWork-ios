//
//  SFFolderViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFFolderViewController : SFBaseViewController

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *type;


@end

NS_ASSUME_NONNULL_END