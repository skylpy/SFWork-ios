//
//  SFLocationInforViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AttendanceDateModel;
@interface SFLocationInforViewController : SFBaseViewController

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) void (^selectTimeClick)(NSArray * selectArr);

@end

NS_ASSUME_NONNULL_END
