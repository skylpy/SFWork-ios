//
//  SFDataProjectsViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFDataProjectsViewController : SFBaseViewController

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) void (^datasClick)(NSArray * list);

@end

NS_ASSUME_NONNULL_END
